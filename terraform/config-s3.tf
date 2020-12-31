##############################
# S3 bucket for AWS Config   #
##############################
# See: https://docs.aws.amazon.com/config/latest/developerguide/gs-cli-prereq.html

# S3 bucket policy for a logging bucket in another account
# See: https://docs.aws.amazon.com/config/latest/developerguide/s3-bucket-policy.html
data "aws_iam_policy_document" "config-bucket-policy" {
  version = "2012-10-17"

  # Get bucket ACL
  statement {
    sid       = "AWSConfigBucketPermissionsCheck"
    effect    = "Allow"
    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.config-bucket.arn]

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
    resources = [aws_s3_bucket.config-bucket.arn]

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
    resources = ["${aws_s3_bucket.config-bucket.arn}/AWSLogs/${local.caller_identity.id}/Config/*"]

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

resource "aws_s3_bucket" "config-bucket" {
  # Set the provider to organisation-security, as that's where we manage Config aggregation
  provider = aws.organisation-security-eu-west-2

  bucket_prefix = "moj-config"
  acl           = "private"

  # NB: AWS Config can't deliver to buckets with object lock turned on, which is why
  # it's not configured.

  server_side_encryption_configuration {
    rule {
      # We don't use a different KMS key as Config stores objects already encrypted with
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

  tags = merge(
    local.tags-organisation-management, {
      component = "Security"
    }
  )
}

resource "aws_s3_bucket_policy" "config-bucket-policy" {
  # Set the provider to organisation-security, as that's where we manage Config aggregation
  provider = aws.organisation-security-eu-west-2

  bucket = aws_s3_bucket.config-bucket.id
  policy = data.aws_iam_policy_document.config-bucket-policy.json
}
