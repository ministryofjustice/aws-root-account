locals {
  wiz_enabled      = true
  wiz_excluded_ous = [local.ou_opg]

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

# Derived from the data source so module inputs stay unknown during validate and
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
  wiz_target_ou_ids = local.wiz_connector == null ? null : local.wiz_target_ou_ids
  wiz_tags          = local.tags_organisation_management

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

  bucket = "posture-management-${data.aws_caller_identity.current.account_id}"

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

output "posture_management_state_bucket" {
  value       = module.posture_management_state_s3_bucket.s3_bucket_id
  description = "S3 bucket for Wiz-as-code (posture management) Terraform state"
}
