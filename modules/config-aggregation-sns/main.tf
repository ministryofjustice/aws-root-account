############################
# SNS topic for AWS Config #
############################
# See: https://docs.aws.amazon.com/config/latest/developerguide/gs-cli-prereq.html

data "aws_caller_identity" "current" {}

locals {
  caller_identity    = data.aws_caller_identity.current
  allowed_principals = formatlist("arn:aws:iam::%s:root", concat([local.caller_identity.id], var.enrolled_account_ids))
}

# Note that SNS topics in AWS Config only support same region and cross account access,
# so you need to configure a new one for each region Config is enabled in.

# SNS topic policy for a SNS topic in another account
# See: https://docs.aws.amazon.com/config/latest/developerguide/sns-topic-policy.html
data "aws_iam_policy_document" "sns_topic" {
  version = "2012-10-17"

  statement {
    effect    = "Allow"
    actions   = ["SNS:Publish"]
    resources = [aws_sns_topic.sns_topic.arn]

    principals {
      type        = "AWS"
      identifiers = var.enrolled_account_ids
    }
  }
}

resource "aws_sns_topic" "sns_topic" {
  name              = "config-sns-topic"
  kms_master_key_id = aws_kms_key.config.id

  tags = var.tags
}

resource "aws_sns_topic_policy" "sns_topic" {
  arn    = aws_sns_topic.sns_topic.arn
  policy = data.aws_iam_policy_document.sns_topic.json
}

##############################
# KMS key for the SNS topic  #
# for AWS Config             #
##############################
data "aws_iam_policy_document" "kms_key_policy" {
  statement {
    sid       = "Allow Config to use the key"
    effect    = "Allow"
    actions   = ["kms:GenerateDataKey"]
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
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
      type        = "AWS"
      identifiers = local.allowed_principals
    }
  }
}

resource "aws_kms_key" "config" {
  description             = "KMS key for AWS Config to encrypt SNS topic notifications"
  deletion_window_in_days = 30
  is_enabled              = true
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_key_policy.json

  tags = var.tags
}
