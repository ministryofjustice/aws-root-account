locals {
  wiz_enabled      = true
  wiz_excluded_ous = []

  # Every top-level OU except excluded ones. StackSets also deploy to
  # descendant OUs and to accounts that later join any targeted OU.
  wiz_target_ou_ids = [
    for ou in data.aws_organizations_organizational_units.organizational_units.children : ou.id
    if !contains(local.wiz_excluded_ous, ou.id)
  ]
}

# Populated out-of-band as {"external_id": "<External ID>", "role_arn": "<Wiz trust role ARN>"}.
# Only read while enabled: a secret without a value cannot be read.
data "aws_secretsmanager_secret_version" "wiz_external_id" {
  count     = local.wiz_enabled ? 1 : 0
  secret_id = "wiz_external_id"
}

# Derived from the data source so connector inputs stay unknown during validate and
# null while disabled; module inputs are only evaluated while enabled.
locals {
  wiz_secret    = one(data.aws_secretsmanager_secret_version.wiz_external_id[*].secret_string)
  wiz_connector = local.wiz_secret == null ? null : sensitive(jsondecode(local.wiz_secret))
}

module "wiz_stackset" {
  source = "../../modules/wiz-stackset"
  count  = local.wiz_enabled ? 1 : 0

  wiz_role_arn      = local.wiz_connector.role_arn
  wiz_external_id   = local.wiz_connector.external_id
  wiz_target_ou_ids = local.wiz_target_ou_ids
  wiz_tags          = local.tags_organisation_management

  # Keep member stacks if Terraform ever destroys an OU deployment target.
  wiz_retain_on_target_destroy = true

  # Deploy to 25 accounts at once; stop after more than 5 failures.
  wiz_concurrency_mode        = "SOFT_FAILURE_TOLERANCE"
  wiz_max_concurrent_count    = 50
  wiz_failure_tolerance_count = 15

  wiz_template_parameters = {
    CloudCostScanning       = "Enabled"
    DataScanning            = "Disabled"
    EKSScanning             = "Disabled"
    LightsailScanning       = "Disabled"
    RDSLogsScanning         = "Enabled"
    S3AWSLogsScanning       = "Enabled"
    S3InventoryScanning     = "Enabled"
    S3KMSDecrypt            = "Enabled"
    TerraformBucketScanning = "Enabled"
  }
}

# One-off migration from the single all-OU stack set instance to one per OU.
# The module's removed block forgets the old instance without deleting stacks;
# these imports adopt each OU that was already targeted. OPG was excluded until
# now, so it is created rather than imported. Remove once applied.
import {
  for_each = local.wiz_enabled ? setsubtract(toset(local.wiz_target_ou_ids), toset([local.ou_opg])) : toset([])
  to       = module.wiz_stackset[0].aws_cloudformation_stack_set_instance.wiz_ou[each.key]
  id       = "${module.wiz_stackset[0].wiz_stackset_name},${each.key},${module.wiz_stackset[0].wiz_deployment_region},DELEGATED_ADMIN"
}

output "wiz_stackset_id" {
  value       = one(module.wiz_stackset[*].wiz_stackset_id)
  description = "Wiz StackSet identifier; null while the trial is disabled. Check individual stack instance health separately."
}

# Terraform state for managing Wiz itself as code (projects, policies, users).
# Locking uses S3 native lock files (`use_lockfile = true` in the consumer's backend), so no DynamoDB table.
module "posture_management_state_kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 4.2"

  description             = "Encrypts the posture-management Terraform state bucket"
  enable_key_rotation     = true
  deletion_window_in_days = 30
  aliases                 = ["posture-management-state"]

  tags = local.tags_organisation_management
}

module "posture_management_state_s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.17"

  # Fixed name (no account ID) so consumers can hard-code it in their backend block.
  bucket = "moj-posture-management-terraform-state"

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = module.posture_management_state_kms.key_arn
      }
      bucket_key_enabled = true
    }
  }

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  control_object_ownership = true
  object_ownership         = "BucketOwnerEnforced"

  attach_deny_insecure_transport_policy = true
  attach_require_latest_tls_policy      = true

  # Expire superseded state versions after 90 days; current state is never expired.
  lifecycle_rule = [
    {
      id      = "expire-noncurrent-state"
      enabled = true
      noncurrent_version_expiration = {
        days = 90
      }
      abort_incomplete_multipart_upload_days = 7
    }
  ]

  tags = local.tags_organisation_management
}

# GitHub Actions roles for ministryofjustice/cloud-security-posture-management-configuration.
# Both only reach the state bucket and its key; Wiz API credentials are GitHub secrets, not AWS.
locals {
  posture_management_repo       = "ministryofjustice/cloud-security-posture-management-configuration"
  posture_management_bucket_arn = module.posture_management_state_s3_bucket.s3_bucket_arn
}

# Pull requests: read state, and write/delete only the S3 lock file during plan.
module "posture_management_plan_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "~> 6.8"

  name               = "posture-management-plan"
  use_name_prefix    = false
  enable_github_oidc = true
  oidc_subjects      = ["repo:${local.posture_management_repo}:pull_request"]

  create_inline_policy = true
  inline_policy_permissions = {
    ListStateBucket = {
      actions   = ["s3:ListBucket"]
      resources = [local.posture_management_bucket_arn]
    }
    ReadState = {
      actions   = ["s3:GetObject"]
      resources = ["${local.posture_management_bucket_arn}/*"]
    }
    WriteLockFile = {
      actions   = ["s3:PutObject", "s3:DeleteObject"]
      resources = ["${local.posture_management_bucket_arn}/*.tflock"]
    }
    UseStateKey = {
      actions   = ["kms:Decrypt", "kms:GenerateDataKey"]
      resources = [module.posture_management_state_kms.key_arn]
    }
  }

  tags = local.tags_organisation_management
}

# main branch: read and write state.
module "posture_management_apply_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "~> 6.8"

  name               = "posture-management-apply"
  use_name_prefix    = false
  enable_github_oidc = true
  oidc_subjects      = ["repo:${local.posture_management_repo}:ref:refs/heads/main"]

  create_inline_policy = true
  inline_policy_permissions = {
    ListStateBucket = {
      actions   = ["s3:ListBucket"]
      resources = [local.posture_management_bucket_arn]
    }
    ReadWriteState = {
      actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
      resources = ["${local.posture_management_bucket_arn}/*"]
    }
    UseStateKey = {
      actions   = ["kms:Decrypt", "kms:Encrypt", "kms:GenerateDataKey"]
      resources = [module.posture_management_state_kms.key_arn]
    }
  }

  tags = local.tags_organisation_management
}

output "posture_management_state_bucket" {
  value       = module.posture_management_state_s3_bucket.s3_bucket_id
  description = "S3 bucket for Wiz-as-code (posture management) Terraform state"
}

output "posture_management_plan_role_arn" {
  value       = module.posture_management_plan_role.arn
  description = "Role for posture-management pull request plans"
}

output "posture_management_apply_role_arn" {
  value       = module.posture_management_apply_role.arn
  description = "Role for posture-management applies from main"
}
