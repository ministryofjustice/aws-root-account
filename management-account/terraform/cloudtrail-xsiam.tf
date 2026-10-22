locals {
  xsiam_cloudtrail_log_prefix = "AWSLogs/${data.aws_caller_identity.current.account_id}/CloudTrail/"
}

module "xsiam_cloudtrail_topic" {
  source  = "terraform-aws-modules/sns/aws"
  version = "6.2.0"

  name                        = "xsiam-cloudtrail"
  kms_master_key_id           = aws_kms_key.xsiam_cloudtrail.arn
  enable_default_topic_policy = false

  topic_policy_statements = {
    s3_publish = {
      sid        = "AllowCloudTrailBucketNotifications"
      actions    = ["sns:Publish"]
      principals = [{ type = "Service", identifiers = ["s3.amazonaws.com"] }]
      conditions = [
        { test = "ArnEquals", variable = "aws:SourceArn", values = [module.cloudtrail_s3_bucket.bucket.arn] },
        { test = "StringEquals", variable = "aws:SourceAccount", values = [data.aws_caller_identity.current.account_id] }
      ]
    }
    deny_insecure_transport = {
      sid        = "DenyInsecureTransport"
      effect     = "Deny"
      actions    = ["sns:Publish"]
      principals = [{ type = "AWS", identifiers = ["*"] }]
      conditions = [{ test = "Bool", variable = "aws:SecureTransport", values = ["false"] }]
    }
  }
}

module "xsiam_cloudtrail_queue" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "5.0.0"

  name                       = "xsiam-cloudtrail"
  create_queue_policy        = true
  kms_master_key_id          = aws_kms_key.xsiam_cloudtrail.arn
  sqs_managed_sse_enabled    = false
  message_retention_seconds  = 604800
  receive_wait_time_seconds  = 20
  visibility_timeout_seconds = 300

  create_dlq                    = true
  dlq_name                      = "xsiam-cloudtrail-dlq"
  dlq_kms_master_key_id         = aws_kms_key.xsiam_cloudtrail.arn
  dlq_sqs_managed_sse_enabled   = false
  dlq_message_retention_seconds = 1209600
  redrive_policy = {
    maxReceiveCount = 5
  }

  queue_policy_statements = {
    sns_publish = {
      sid        = "AllowCloudTrailTopicNotifications"
      actions    = ["sqs:SendMessage"]
      principals = [{ type = "Service", identifiers = ["sns.amazonaws.com"] }]
      conditions = [
        { test = "ArnEquals", variable = "aws:SourceArn", values = [module.xsiam_cloudtrail_topic.topic_arn] },
        { test = "StringEquals", variable = "aws:SourceAccount", values = [data.aws_caller_identity.current.account_id] }
      ]
    }
    deny_insecure_transport = {
      sid        = "DenyInsecureTransport"
      effect     = "Deny"
      actions    = ["sqs:*"]
      principals = [{ type = "AWS", identifiers = ["*"] }]
      conditions = [{ test = "Bool", variable = "aws:SecureTransport", values = ["false"] }]
    }
  }
}

resource "aws_sns_topic_subscription" "xsiam_cloudtrail" {
  topic_arn            = module.xsiam_cloudtrail_topic.topic_arn
  protocol             = "sqs"
  endpoint             = module.xsiam_cloudtrail_queue.queue_arn
  raw_message_delivery = true

  depends_on = [
    module.xsiam_cloudtrail_queue,
    aws_kms_key_policy.xsiam_cloudtrail
  ]
}

resource "aws_s3_bucket_notification" "xsiam_cloudtrail" {
  bucket = module.cloudtrail_s3_bucket.bucket_name

  topic {
    id            = "xsiam-cloudtrail"
    topic_arn     = module.xsiam_cloudtrail_topic.topic_arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = local.xsiam_cloudtrail_log_prefix
    filter_suffix = ".json.gz"
  }

  depends_on = [
    module.xsiam_cloudtrail_topic,
    aws_sns_topic_subscription.xsiam_cloudtrail,
    aws_iam_role_policy_attachment.xsiam_cloudtrail
  ]
}