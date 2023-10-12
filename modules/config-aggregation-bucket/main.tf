############################
# S3 bucket for AWS Config #
############################
# See: https://docs.aws.amazon.com/config/latest/developerguide/gs-cli-prereq.html

data "aws_caller_identity" "current" {}

locals {
  caller_identity                     = data.aws_caller_identity.current
  bucket_policy_allowed_object_prefix = formatlist("${aws_s3_bucket.bucket.arn}/AWSLogs/%s/Config/*", concat([local.caller_identity.id], var.enrolled_account_ids))
}

# S3 bucket policy for a logging bucket in another account
# See: https://docs.aws.amazon.com/config/latest/developerguide/s3-bucket-policy.html
data "aws_iam_policy_document" "bucket_policy" {
  version = "2012-10-17"

  # Get bucket ACL
  statement {
    sid       = "AWSConfigBucketPermissionsCheck"
    effect    = "Allow"
    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.bucket.arn]

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }

  # List bucket
  statement {
    sid       = "AWSConfigBucketExistenceCheck"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.bucket.arn]

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }

  # Deliver logs to the correct prefix
  statement {
    sid       = "AWSConfigBucketDelivery"
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = local.bucket_policy_allowed_object_prefix

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket_prefix = var.bucket_prefix
  acl           = "private"

  # NB: AWS Config can't deliver to buckets with object lock turned on, which is why
  # it's not configured.

  server_side_encryption_configuration {
    rule {
      # You can't use a different KMS key as Config stores objects already encrypted with
      # the AWS managed S3 KMS key
      apply_server_side_encryption_by_default {
        kms_master_key_id = "aws/s3"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = var.tags
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}
