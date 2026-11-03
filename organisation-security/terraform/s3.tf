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

resource "random_integer" "suffix" {
  min = 10000000000
  max = 90000000000
}

# cf-template-storage
module "cf_template_storage" {
  source          = "../../modules/s3"
  additional_tags = local.tags_organisation_management
  bucket_prefix   = "cf-template-storage"
}

# cloudtrail--replication
module "cloudtrail_replication_s3_bucket" {
  providers = {
    aws = aws.eu-west-1
  }
  source = "../../modules/s3"

  bucket_name = "cloudtrail--replication-${random_integer.suffix.result}"

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

# cloudtrail
module "cloudtrail_s3_bucket" {
  source = "../../modules/s3"

  bucket_name      = "cloudtrail-${random_integer.suffix.result}"
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
    resources = ["arn:aws:s3:::cloudtrail-${random_integer.suffix.result}"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::cloudtrail-${random_integer.suffix.result}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

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

# Athena
module "athena_results_s3_bucket" {
  source = "../../modules/s3"

  bucket_name = "athena-results-${random_integer.suffix.result}"
  bucket_acl  = "private"

  attach_policy        = false
  require_ssl_requests = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "aws:kms"
      }
    }
  }
}

# organisation-cloudtrail
# See: https://docs.aws.amazon.com/awscloudtrail/latest/userguide/create-s3-bucket-policy-for-cloudtrail.html#org-trail-bucket-policy
data "aws_iam_policy_document" "organisation_cloudtrail_s3_bucket" {
  statement {
    sid       = "CloudTrailAclCheck"
    effect    = "Allow"
    actions   = ["s3:GetBucketAcl"]
    resources = [local.organisation_cloudtrail_bucket_arn]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [local.organisation_cloudtrail_arn]
    }
  }

  statement {
    sid     = "CloudTrailWrite"
    effect  = "Allow"
    actions = ["s3:PutObject"]
    resources = [
      "${local.organisation_cloudtrail_bucket_arn}/AWSLogs/${local.root_account_id}/*",
      "${local.organisation_cloudtrail_bucket_arn}/AWSLogs/${local.organizations_organization.id}/*",
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [local.organisation_cloudtrail_arn]
    }
  }
}

module "organisation_cloudtrail_s3_bucket" {
  #checkov:skip=CKV_TF_1:Module registry does not support commit hashes for versions
  #checkov:skip=CKV_TF_2:Module registry does not support tags for versions
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.17.0"

  # Fixed name (no account ID) so the Wiz connector can reference it.
  bucket        = local.organisation_cloudtrail_bucket_name
  force_destroy = false

  control_object_ownership = true
  object_ownership         = "BucketOwnerEnforced"

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = module.organisation_cloudtrail_kms.key_arn
      }
      bucket_key_enabled = true
    }
  }

  attach_deny_insecure_transport_policy = true
  attach_require_latest_tls_policy      = true
  attach_policy                         = true
  policy                                = data.aws_iam_policy_document.organisation_cloudtrail_s3_bucket.json

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  lifecycle_rule = [
    {
      id      = "organisation-cloudtrail-retention"
      enabled = true
      filter = {
        prefix = local.organisation_cloudtrail_log_prefix
      }
      transition = [
        {
          days          = local.organisation_cloudtrail_transition_days
          storage_class = "GLACIER_IR"
        }
      ]
      expiration = {
        days = local.organisation_cloudtrail_expiration_days
      }
      noncurrent_version_expiration = {
        days = local.organisation_cloudtrail_noncurrent_expiry_days
      }
      abort_incomplete_multipart_upload_days = 7
    }
  ]

  tags = local.organisation_cloudtrail_tags
}

# New log files -> SNS -> SQS (Wiz). One notification configuration per bucket.
resource "aws_s3_bucket_notification" "organisation_cloudtrail" {
  bucket = module.organisation_cloudtrail_s3_bucket.s3_bucket_id

  topic {
    id            = local.organisation_cloudtrail_sns_topic
    topic_arn     = module.organisation_cloudtrail_sns.topic_arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = local.organisation_cloudtrail_log_prefix
    filter_suffix = ".json.gz"
  }

  depends_on = [module.organisation_cloudtrail_sns]
}
