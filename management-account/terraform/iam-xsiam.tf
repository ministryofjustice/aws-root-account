resource "random_uuid" "xsiam_cloudtrail" {}

data "aws_iam_policy_document" "xsiam_cloudtrail_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::006742885340:root"]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [sensitive(random_uuid.xsiam_cloudtrail.result)]
    }
  }
}

resource "aws_iam_role" "xsiam_cloudtrail" {
  name               = "xsiam-cloudtrail"
  description        = "Allows Cortex XSIAM to collect this account's CloudTrail logs"
  assume_role_policy = data.aws_iam_policy_document.xsiam_cloudtrail_trust.json
}

data "aws_iam_policy_document" "xsiam_cloudtrail" {
  statement {
    sid       = "ReadCloudTrailLogs"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${module.cloudtrail_s3_bucket.bucket.arn}/${local.xsiam_cloudtrail_log_prefix}*"]
  }

  statement {
    sid    = "ConsumeCloudTrailNotifications"
    effect = "Allow"
    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:ReceiveMessage"
    ]
    resources = [module.xsiam_cloudtrail_queue.queue_arn]
  }

  statement {
    sid     = "DecryptCloudTrailLogsAndNotifications"
    effect  = "Allow"
    actions = ["kms:Decrypt"]
    resources = [
      module.cloudtrail.kms_key_arn,
      aws_kms_key.xsiam_cloudtrail.arn
    ]
  }
}

module "xsiam_cloudtrail_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "6.8.2"

  name        = "xsiam-cloudtrail"
  description = "Read CloudTrail objects and consume the dedicated XSIAM notification queue"
  policy      = data.aws_iam_policy_document.xsiam_cloudtrail.json
}

resource "aws_iam_role_policy_attachment" "xsiam_cloudtrail" {
  role       = aws_iam_role.xsiam_cloudtrail.name
  policy_arn = module.xsiam_cloudtrail_policy.arn
}