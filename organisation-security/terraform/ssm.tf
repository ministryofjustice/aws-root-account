# SSM Resource sync for syncing inventory data from around the organisation centrally
# KMS key for resource sync
resource "aws_kms_key" "ssm_resource_sync" {
  description         = "Used for SSM Resource Sync from org member accounts"
  policy              = data.aws_iam_policy_document.ssm_resource_sync_kms.json
  is_enabled          = true
  enable_key_rotation = true
}

resource "aws_kms_alias" "ssm_resource_sync" {
  name          = "alias/ssm-resource-sync"
  target_key_id = aws_kms_key.ssm_resource_sync.key_id
}

data "aws_iam_policy_document" "ssm_resource_sync_kms" {
  statement {
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
  statement {
    sid       = "ssm-access-policy-statement"
    effect    = "Allow"
    actions   = ["kms:GenerateDataKey"]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = local.organisation_account_numbers
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:ssm:*:*:resource-data-sync/*"]
    }
  }
  statement {
    sid       = "glue-crawler-access"
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

module "ssm_resource_sync_s3_bucket" {
  source = "../../modules/s3"

  bucket_name = "ssm-resource-sync-${random_integer.suffix.result}"
  bucket_acl  = "private"

  attach_policy        = true
  policy               = data.aws_iam_policy_document.ssm_resource_sync_s3_bucket.json
  require_ssl_requests = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "aws:kms"
      }
    }
  }
}

data "aws_iam_policy_document" "ssm_resource_sync_s3_bucket" {
  statement {
    sid       = "SSMBucketDelivery"
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::ssm-resource-sync-${random_integer.suffix.result}/*"]

    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = local.organisation_account_numbers
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:ssm:*:*:resource-data-sync/*"]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["aws:kms"]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      values   = [aws_kms_key.ssm_resource_sync.arn]
    }
  }
}
