#########################################
# Configures the publishing destination #
# S3 bucket with a KMS key              #
#########################################

#########################################
# S3 bucket                             #
#########################################
# See: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_exportfindings.html

data "aws_iam_policy_document" "guardduty-publishing-destination-s3-bucket-policy" {
  version = "2012-10-17"

  statement {
    sid       = "Allow GuardDuty to use the getBucketLocation operation"
    effect    = "Allow"
    actions   = ["s3:GetBucketLocation"]
    resources = [aws_s3_bucket.guardduty-bucket.arn]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
  }

  statement {
    sid       = "Allow GuardDuty to upload objects to the bucket"
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.guardduty-bucket.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
  }

  statement {
    sid       = "Deny unencrypted object uploads"
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.guardduty-bucket.arn}/*"]

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
    resources = ["${aws_s3_bucket.guardduty-bucket.arn}/*"]

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
    resources = ["${aws_s3_bucket.guardduty-bucket.arn}/*"]

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

resource "aws_s3_bucket" "guardduty-bucket" {
  # Set the provider to organisation-security, as that's where we manage GuardDuty
  provider = aws.organisation-security-eu-west-2

  bucket_prefix = "moj-guardduty"
  acl           = "private"

  object_lock_configuration {
    object_lock_enabled = "Enabled"
    rule {
      # There are two modes of retention: Governance, or Compliance
      # Governance is a soft retention period, whereas Compliance is a legal hold
      # that can't be bypassed and requires you to delete an AWS account in its entirety to bypass it
      # See: https://docs.aws.amazon.com/AmazonS3/latest/dev/object-lock-overview.html
      default_retention {
        mode = "GOVERNANCE"
        days = 60
      }
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.guardduty.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = merge(
    local.tags-organisation-management, {
      component = "Security"
    }
  )
}

resource "aws_s3_bucket_public_access_block" "guardduty-bucket-public-access-block" {
  # Set the provider to organisation-security, as that's where we manage GuardDuty
  provider = aws.organisation-security-eu-west-2

  bucket = aws_s3_bucket.guardduty-bucket.id

  # Block public ACLs
  block_public_acls = true

  # Block public bucket policies
  block_public_policy = true

  # Ignore public ACLs
  ignore_public_acls = true

  # Restrict public bucket policies
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "guardduty-bucket-policy" {
  # Set the provider to organisation-security, as that's where we manage GuardDuty
  provider = aws.organisation-security-eu-west-2

  bucket = aws_s3_bucket.guardduty-bucket.id
  policy = data.aws_iam_policy_document.guardduty-publishing-destination-s3-bucket-policy.json
}

#########################################
# KMS policy                            #
#########################################
# See: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_exportfindings.html
data "aws_iam_policy_document" "guardduty-kms-key-policy" {
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
        "arn:aws:iam::${local.caller_identity.id}:root",                          # Allow the root account to manage this key
        "arn:aws:iam::${aws_organizations_account.organisation-security.id}:root" # Allow the organisation-security account to manage this key
      ]
    }
  }
}

resource "aws_kms_key" "guardduty" {
  # Set the provider to organisation-security, as that's where we manage GuardDuty
  provider = aws.organisation-security-eu-west-2

  description             = "KMS key for AWS GuardDuty to encrypt findings for publishing to S3"
  deletion_window_in_days = 30
  is_enabled              = true
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.guardduty-kms-key-policy.json

  tags = merge(
    local.tags-organisation-management, {
      component = "Security"
    }
  )
}
