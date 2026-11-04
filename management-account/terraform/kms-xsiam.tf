resource "aws_kms_key" "xsiam_cloudtrail" {
  description         = "Encrypts the dedicated CloudTrail notification topic and queues for XSIAM"
  enable_key_rotation = true
}

resource "aws_kms_alias" "xsiam_cloudtrail" {
  name          = "alias/xsiam-cloudtrail"
  target_key_id = aws_kms_key.xsiam_cloudtrail.key_id
}

data "aws_iam_policy_document" "xsiam_cloudtrail_kms" {
  statement {
    sid       = "EnableAccountPermissions"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    sid       = "AllowCloudTrailBucketNotifications"
    effect    = "Allow"
    actions   = ["kms:GenerateDataKey", "kms:Decrypt"]
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [module.cloudtrail_s3_bucket.bucket.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }

  statement {
    sid       = "AllowCloudTrailTopicNotifications"
    effect    = "Allow"
    actions   = ["kms:GenerateDataKey", "kms:Decrypt"]
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [module.xsiam_cloudtrail_topic.topic_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

resource "aws_kms_key_policy" "xsiam_cloudtrail" {
  key_id = aws_kms_key.xsiam_cloudtrail.id
  policy = data.aws_iam_policy_document.xsiam_cloudtrail_kms.json
}