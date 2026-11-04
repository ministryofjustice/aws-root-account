###################################
# Organisation CloudTrail KMS key #
###################################
# One key for the trail's log files, the notification topic and the queues.
# See: https://docs.aws.amazon.com/awscloudtrail/latest/userguide/create-kms-key-policy-for-cloudtrail.html
data "aws_iam_policy_document" "organisation_cloudtrail_kms" {
  statement {
    sid       = "AccountAdmin"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    sid       = "CloudTrailEncrypt"
    effect    = "Allow"
    actions   = ["kms:GenerateDataKey*"]
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [local.organisation_cloudtrail_arn]
    }

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = ["arn:aws:cloudtrail:*:${local.root_account_id}:trail/${local.organisation_cloudtrail_name}"]
    }
  }

  statement {
    sid       = "CloudTrailDescribeKey"
    effect    = "Allow"
    actions   = ["kms:DescribeKey"]
    resources = ["*"]

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

  # S3 publishes to the encrypted topic.
  statement {
    sid       = "S3PublishToTopic"
    effect    = "Allow"
    actions   = ["kms:GenerateDataKey*", "kms:Decrypt"]
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [local.organisation_cloudtrail_bucket_arn]
    }
  }

  # SNS delivers to the encrypted queue.
  statement {
    sid       = "SnsDeliverToQueue"
    effect    = "Allow"
    actions   = ["kms:GenerateDataKey*", "kms:Decrypt"]
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [local.organisation_cloudtrail_sns_topic_arn]
    }
  }

  dynamic "statement" {
    for_each = local.wiz_enabled ? [1] : []

    content {
      sid       = "WizDecrypt"
      effect    = "Allow"
      actions   = ["kms:Decrypt", "kms:DescribeKey"]
      resources = ["*"]

      principals {
        type        = "AWS"
        identifiers = [data.aws_iam_role.wiz[0].arn]
      }
    }
  }
}

module "organisation_cloudtrail_kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "4.2.2"

  description             = "Encrypts organisation CloudTrail log files and their notification topic and queues"
  aliases                 = [local.organisation_cloudtrail_kms_alias]
  enable_key_rotation     = true
  deletion_window_in_days = 30

  enable_default_policy     = false
  override_policy_documents = [data.aws_iam_policy_document.organisation_cloudtrail_kms.json]

  tags = local.organisation_cloudtrail_tags
}
