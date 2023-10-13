#########################################
# Configures the publishing destination #
# S3 bucket with a KMS key              #
#########################################

#########################################
# S3 bucket                             #
#########################################
# See: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_exportfindings.html

locals {
  tags_organisation_management = {
    application            = "Organisation Management"
    business-unit          = "Platforms"
    infrastructure-support = "Hosting Leads: hosting-leads@digital.justice.gov.uk"
    is-production          = true
    owner                  = "Hosting Leads: hosting-leads@digital.justice.gov.uk"
    source-code            = "github.com/ministryofjustice/aws-root-account"
  }
}

data "aws_iam_policy_document" "guardduty_publishing_destination_s3_bucket_policy" {
  version = "2012-10-17"

  statement {
    sid       = "Allow GuardDuty to use the getBucketLocation operation"
    effect    = "Allow"
    actions   = ["s3:GetBucketLocation"]
    resources = [module.guardduty_publishing_destination_s3_bucket.bucket.arn]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
  }

  statement {
    sid       = "Allow GuardDuty to upload objects to the bucket"
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${module.guardduty_publishing_destination_s3_bucket.bucket.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
  }

  statement {
    sid       = "Deny unencrypted object uploads"
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["${module.guardduty_publishing_destination_s3_bucket.bucket.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["aws:kms"]
    }
  }

  statement {
    sid       = "Deny incorrect encryption header"
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["${module.guardduty_publishing_destination_s3_bucket.bucket.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      values   = [aws_kms_key.guardduty.arn]
    }
  }

  statement {
    sid       = "Deny non-HTTPS access"
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = ["${module.guardduty_publishing_destination_s3_bucket.bucket.arn}/*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

module "guardduty_publishing_destination_s3_bucket" {
  source = "../../modules/s3"

  bucket_prefix = "moj-guardduty"

  attach_policy = true
  policy        = data.aws_iam_policy_document.guardduty_publishing_destination_s3_bucket_policy.json

  enable_versioning   = true
  object_lock_enabled = true
  object_lock_retention = {
    rule = {
      default_retention = {
        mode = "GOVERNANCE"
        days = 60
      }
    }
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.guardduty.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  additional_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
    }
  )
}

#########################################
# KMS policy                            #
#########################################
# See: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_exportfindings.html
data "aws_iam_policy_document" "guardduty_kms_key_policy" {
  statement {
    sid       = "Allow GuardDuty to use the key"
    effect    = "Allow"
    actions   = ["kms:GenerateDataKey"]
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
  }

  # You also need to explicitly allow accounts to update and manage the key, otherwise
  # it becomes unmanageable
  # See: https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html#key-policy-default
  statement {
    sid       = "Allow key management"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${local.root_account_id}:root",              # Allow the root account to manage this key
        "arn:aws:iam::${data.aws_caller_identity.current.id}:root" # Allow the organisation-security account to manage this key
      ]
    }
  }
}

resource "aws_kms_key" "guardduty" {
  description             = "KMS key for AWS GuardDuty to encrypt findings for publishing to S3"
  deletion_window_in_days = 30
  is_enabled              = true
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.guardduty_kms_key_policy.json

  tags = merge(
    local.tags_organisation_management, {
      component = "Security"
    }
  )
}
