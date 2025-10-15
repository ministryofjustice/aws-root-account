########################################
# S3 account-level public access block #
########################################

resource "aws_s3_account_public_access_block" "default" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

##############
# S3 buckets #
##############

# AWS Config log bucket
module "config_log_bucket" {
  source = "../../modules/config-bucket"
}

# cloudtrail--replication20210315101340520100000002
module "cloudtrail_replication_s3_bucket" {
  providers = {
    aws = aws.eu-west-1
  }
  source           = "../../modules/s3"
  object_ownership = "ObjectWriter"
  bucket_name      = "cloudtrail--replication20210315101340520100000002"

  attach_policy        = true
  require_ssl_requests = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = module.cloudtrail.kms_key_arn
      }
    }
  }
}

# cloudtrail-20210315101356188000000003
module "cloudtrail_s3_bucket" {
  source = "../../modules/s3"

  bucket_name      = "cloudtrail-20210315101356188000000003"
  bucket_acl       = "log-delivery-write"
  object_ownership = "ObjectWriter"

  attach_policy        = true
  policy               = data.aws_iam_policy_document.cloudtrail_s3_bucket.json
  require_ssl_requests = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = module.cloudtrail.kms_key_arn
      }
    }
  }
}

data "aws_iam_policy_document" "cloudtrail_s3_bucket" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::cloudtrail-20210315101356188000000003"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::cloudtrail-20210315101356188000000003/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

# log-bucket-replication20210315101330747900000001
module "log_bucket_replication_s3_bucket" {
  providers = {
    aws = aws.eu-west-1
  }
  source = "../../modules/s3"

  bucket_name = "log-bucket-replication20210315101330747900000001"

  attach_policy        = true
  require_ssl_requests = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "aws:kms"
      }
    }
  }
}

# log-bucket20210315101344444500000002
module "log_bucket_s3_bucket" {
  source = "../../modules/s3"

  bucket_name = "log-bucket20210315101344444500000002"

  attach_policy        = true
  require_ssl_requests = true
  object_ownership     = "ObjectWriter"

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "aws:kms"
      }
    }
  }
}

# moj-aws-root-account-terraform-state
module "terraform_state_s3_bucket" {
  source = "../../modules/s3"

  bucket_name = "moj-aws-root-account-terraform-state"

  attach_policy = true
  policy        = data.aws_iam_policy_document.terraform_state_s3_bucket.json
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = resource.aws_kms_key.terraform_state_s3_bucket.id
      }
    }
  }
}

data "aws_iam_policy_document" "terraform_state_s3_bucket" {
  statement {
    sid    = "AllowReadAccessFromSecurityAccount"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetObject"
    ]
    resources = [
      module.terraform_state_s3_bucket.bucket.arn,
      "${module.terraform_state_s3_bucket.bucket.arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${resource.aws_organizations_account.organisation_security.id}:root"]
    }
  }

  statement {
    sid    = "AllowAccessFromSecurityAccount"
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = ["${module.terraform_state_s3_bucket.bucket.arn}/organisation-security/*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${resource.aws_organizations_account.organisation_security.id}:root"]
    }
  }
}

# moj-cur-reports
module "cur_reports_s3_bucket" {
  source = "../../modules/s3"

  bucket_name            = "moj-cur-reports"
  attach_policy          = true
  policy                 = data.aws_iam_policy_document.cur_reports_s3_bucket.json
  enable_replication     = true
  replication_bucket_arn = "arn:aws:s3:::moj-cur-reports-modplatform-20241021144023194000000001"
  replication_role_arn   = module.cur_reports_s3_bucket.replication_role_arn
  source_kms_arn         = data.aws_kms_alias.moj_cur_reports_kms_alias.target_key_arn
  destination_kms_arn    = data.aws_ssm_parameter.core_logging_kms_key_arn.value
  replication_rules = [
    {
      id                 = "replicate-cur-athena"
      prefix             = "CUR-ATHENA/"
      status             = "Enabled"
      deletemarker       = "Enabled"
      replica_kms_key_id = data.aws_ssm_parameter.core_logging_kms_key_arn.value
      metrics            = "Enabled"
    }
  ]
}

data "aws_ssm_parameter" "core_logging_kms_key_arn" {
  name = "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.current.account_id}:parameter/core-logging-kms-key"
}

data "aws_kms_alias" "moj_cur_reports_kms_alias" {
  name = "alias/aws/s3"
}

data "aws_iam_policy_document" "cur_reports_s3_bucket" {
  version = "2008-10-17"

  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketPolicy",
      "s3:GetBucketAcl"
    ]
    resources = ["arn:aws:s3:::moj-cur-reports"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::386209384616:root"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::moj-cur-reports/*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::386209384616:root"]
    }
  }
}

# moj-cur-reports-quicksight
module "cur_reports_quicksight_s3_bucket" {
  source = "../../modules/s3"

  bucket_name   = "moj-cur-reports-quicksight"
  attach_policy = true
  policy        = data.aws_iam_policy_document.cur_reports_quicksight_s3_policy.json
}

data "aws_iam_policy_document" "cur_reports_quicksight_s3_policy" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketPolicy",
      "s3:GetBucketAcl"
    ]
    resources = ["arn:aws:s3:::moj-cur-reports-quicksight"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::386209384616:root"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::moj-cur-reports-quicksight/*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::386209384616:root"]
    }
  }
}

module "cur_reports_v2_hourly_s3_bucket" {
  #checkov:skip=CKV_TF_1:Module registry does not support commit hashes for versions
  #checkov:skip=CKV_TF_2:Module registry does not support tags for versions
  #checkov:skip=CKV_AWS_18:Access logging not enabled currently
  #checkov:skip=CKV_AWS_21:Versioning is enabled, but not detected by Checkov
  #checkov:skip=CKV_AWS_145:Bucket is encrypted with CMK KMS, but not detected by Checkov
  #checkov:skip=CKV_AWS_300:Lifecycle configuration not enabled currently
  #checkov:skip=CKV_AWS_144:Cross-region replication is not required currently
  #checkov:skip=CKV2_AWS_6:Public access block is enabled, but not detected by Checkov
  #checkov:skip=CKV2_AWS_61:Lifecycle configuration not enabled currently
  #checkov:skip=CKV2_AWS_62:Bucket notifications not required currently
  #checkov:skip=CKV2_AWS_67:Regular CMK key rotation is not required currently

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.7.0"

  bucket        = "moj-cur-reports-v2-hourly"
  force_destroy = true
  attach_policy = true
  policy        = data.aws_iam_policy_document.cur_reports_v2_hourly_s3_policy.json

  versioning = {
    enabled = true
  }

  replication_configuration = {
    role = module.cur_reports_v2_hourly_replication_role.iam_role_arn
    rules = [
      {
        id       = "replicate-cur-v2-reports"
        prefix   = "moj-cost-and-usage-reports/"
        status   = "Enabled"
        priority = 1
        filter = {
          prefix = ""
        }
        delete_marker_replication = true

        source_selection_criteria = {
          sse_kms_encrypted_objects = {
            enabled = true
          }
        }

        destination = {
          account_id    = "279191903737"
          bucket        = "arn:aws:s3:::coat-production-cur-v2-hourly"
          storage_class = "STANDARD"
          access_control_translation = {
            owner = "Destination"
          }
          encryption_configuration = {
            replica_kms_key_id = "arn:aws:kms:eu-west-2:279191903737:key/ef7e1dc9-dc2b-4733-9278-46885b7040c7"
          }
          metrics = {
            status  = "Enabled"
            minutes = 15
          }
          replication_time = {
            status  = "Enabled"
            minutes = 15
          }
        }
      },

      {
        id       = "replicate-cur-v2-reports-mojap"
        prefix   = "mojap-cost-and-usage-reports/"
        status   = "Enabled"
        priority = 0
        filter = {
          prefix = ""
        }
        delete_marker_replication = true

        source_selection_criteria = {
          sse_kms_encrypted_objects = {
            enabled = true
          }
        }

        destination = {
          account_id    = "593291632749"
          bucket        = "arn:aws:s3:::mojap-data-production-coat-cur-reports-v2-hourly"
          storage_class = "STANDARD"
          access_control_translation = {
            owner = "Destination"
          }
          encryption_configuration = {
            replica_kms_key_id = "arn:aws:kms:eu-west-1:593291632749:key/0409ddbc-b6a2-46c4-a613-6145f6a16215"
          }
          metrics = {
            status  = "Enabled"
            minutes = 15
          }
          replication_time = {
            status  = "Enabled"
            minutes = 15
          }
        }
      }
    ]
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = module.cur_v2_s3_kms.key_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

moved {
  from = module.cur_reports_v2_hourly_s3_bucket.aws_s3_bucket.default
  to   = module.cur_reports_v2_hourly_s3_bucket.aws_s3_bucket.this[0]
}

moved {
  from = module.cur_reports_v2_hourly_s3_bucket.aws_s3_bucket_public_access_block.default
  to   = module.cur_reports_v2_hourly_s3_bucket.aws_s3_bucket_public_access_block.this[0]
}

moved {
  from = module.cur_reports_v2_hourly_s3_bucket.aws_s3_bucket_versioning.default["enabled"]
  to   = module.cur_reports_v2_hourly_s3_bucket.aws_s3_bucket_versioning.this[0]
}

moved {
  from = module.cur_reports_v2_hourly_s3_bucket.aws_s3_bucket_server_side_encryption_configuration.default["enabled"]
  to   = module.cur_reports_v2_hourly_s3_bucket.aws_s3_bucket_server_side_encryption_configuration.this[0]
}

moved {
  from = module.cur_reports_v2_hourly_s3_bucket.aws_s3_bucket_replication_configuration.default["enabled"]
  to   = module.cur_reports_v2_hourly_s3_bucket.aws_s3_bucket_replication_configuration.this[0]
}

moved {
  from = module.cur_reports_v2_hourly_s3_bucket.aws_s3_bucket_policy.default["enabled"]
  to   = module.cur_reports_v2_hourly_s3_bucket.aws_s3_bucket_policy.this[0]
}

moved {
  from = module.cur_reports_v2_hourly_s3_bucket.aws_iam_role.replication_role[0]
  to   = module.cur_reports_v2_hourly_replication_role.aws_iam_role.this[0]
}

data "aws_iam_policy_document" "cur_reports_v2_hourly_s3_policy" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketPolicy",
      "s3:GetBucketAcl"
    ]
    resources = ["arn:aws:s3:::moj-cur-reports-v2-hourly"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::386209384616:root"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::moj-cur-reports-v2-hourly/*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::386209384616:root"]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::moj-cur-reports-v2-hourly",
      "arn:aws:s3:::moj-cur-reports-v2-hourly/*"
    ]
    principals {
      type        = "Service"
      identifiers = ["bcm-data-exports.amazonaws.com"]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:GetObjectTagging"
    ]
    resources = [
      "arn:aws:s3:::moj-cur-reports-v2-hourly",
      "arn:aws:s3:::moj-cur-reports-v2-hourly/*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::279191903737:root"]
    }
  }
}

##########################################
# COAT Production Replication Role  #
##########################################

module "cur_reports_v2_hourly_replication_role" {
  #checkov:skip=CKV_TF_1:Module is from Terraform registry
  #checkov:skip=CKV_TF_2:Module registry does not support tags for versions

  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.60.0"

  create_role = true

  role_name         = "moj-cur-reports-v2-hourly-replication-role"
  role_requires_mfa = false

  trusted_role_services = [
    "batchoperations.s3.amazonaws.com",
    "s3.amazonaws.com"
  ]

  custom_role_policy_arns = [module.cur_reports_v2_hourly_replication_policy.arn]
}

data "aws_iam_policy_document" "cur_reports_v2_hourly_replication" {
  statement {
    sid    = "SourceBucketPermissions"
    effect = "Allow"
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket"
    ]
    resources = [module.cur_reports_v2_hourly_s3_bucket.s3_bucket_arn]
  }
  statement {
    sid    = "SourceBucketObjectPermissions"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectTagging",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionTagging",
      "s3:ObjectOwnerOverrideToBucketOwner",
    ]
    resources = ["${module.cur_reports_v2_hourly_s3_bucket.s3_bucket_arn}/*"]
  }
  statement {
    sid    = "DestinationBucketPermissions"
    effect = "Allow"
    actions = [
      "s3:GetObjectVersionTagging",
      "s3:ObjectOwnerOverrideToBucketOwner",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectTagging",
      "s3:ReplicateDelete",
      "s3:ReplicateObject",
      "s3:ReplicateTags"
    ]
    resources = [
      "arn:aws:s3:::mojap-data-production-coat-cur-reports-v2-hourly",
      "arn:aws:s3:::mojap-data-production-coat-cur-reports-v2-hourly/*",
      "arn:aws:s3:::coat-production-cur-v2-hourly",
      "arn:aws:s3:::coat-production-cur-v2-hourly/*"
    ]
  }
  statement {
    sid    = "SourceBucketKMSKey"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]
    resources = [module.cur_v2_s3_kms.key_arn]
  }
  statement {
    sid    = "DestinationBucketKMSKey"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:GenerateDataKey"
    ]
    resources = [
      module.cur_v2_s3_kms.key_arn,
      "arn:aws:kms:eu-west-1:593291632749:key/0409ddbc-b6a2-46c4-a613-6145f6a16215",
      "arn:aws:kms:eu-west-2:279191903737:key/ef7e1dc9-dc2b-4733-9278-46885b7040c7"
    ]
  }
}

module "cur_reports_v2_hourly_replication_policy" {
  #checkov:skip=CKV_TF_1:Module is from Terraform registry
  #checkov:skip=CKV_TF_2:Module registry does not support tags for versions

  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.60.0"
  name    = "${module.cur_reports_v2_hourly_replication_role.iam_role_name}-policy"

  policy = data.aws_iam_policy_document.cur_reports_v2_hourly_replication.json
}

# moj-focus-reports-greenops
data "aws_iam_policy_document" "focus_reports_s3_bucket" {
  version = "2008-10-17"

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::moj-focus-1-reports",
      "arn:aws:s3:::moj-focus-1-reports/*"
    ]
    principals {
      type        = "Service"
      identifiers = ["bcm-data-exports.amazonaws.com"]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:GetObjectTagging"
    ]
    resources = [
      "arn:aws:s3:::moj-focus-1-reports",
      "arn:aws:s3:::moj-focus-1-reports/*"
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::279191903737:root"]
    }
  }
}


# cf-template-storage
module "cf_template_storage" {
  source          = "../../modules/s3"
  additional_tags = local.tags_organisation_management
  bucket_prefix   = "cf-template-storage"
}

module "focus_reports_s3_bucket" {
  source = "../../modules/s3"

  bucket_name       = "moj-focus-1-reports"
  force_destroy     = true
  attach_policy     = true
  policy            = data.aws_iam_policy_document.focus_reports_s3_bucket.json
  enable_versioning = true

  enable_replication     = true
  replication_bucket_arn = "arn:aws:s3:::coat-production-focus-reports"
  replication_role_arn   = module.focus_reports_s3_bucket.replication_role_arn
  destination_kms_arn    = "arn:aws:kms:eu-west-2:279191903737:key/807c9d94-a20e-4df4-b5a9-d8e08bd24323"
  source_kms_arn         = module.focus_s3_kms.key_arn

  replication_rules = [
    {
      id                 = "replicate-focus-reports"
      prefix             = "moj-focus-reports/"
      status             = "Enabled"
      deletemarker       = "Enabled"
      replica_kms_key_id = "arn:aws:kms:eu-west-2:279191903737:key/807c9d94-a20e-4df4-b5a9-d8e08bd24323"
      metrics            = "Enabled"
    }
  ]

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = module.focus_s3_kms.key_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

# moj-optimisation-hub-export

module "optimisation_hub_export_s3_bucket" {
  source = "../../modules/s3"

  bucket_name   = "moj-optimisation-hub-export"
  attach_policy = true
  policy        = data.aws_iam_policy_document.optimisation_hub_export_s3_policy.json

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = module.optimisation_hub_export_s3_kms.key_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

data "aws_iam_policy_document" "optimisation_hub_export_s3_policy" {
  version = "2008-10-17"

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::moj-optimisation-hub-export",
      "arn:aws:s3:::moj-optimisation-hub-export/*"
    ]
    principals {
      type        = "Service"
      identifiers = ["bcm-data-exports.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = ["295814833350"]
    } 
  }
}
