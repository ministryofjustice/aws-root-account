######################################
# Organisation CloudTrail SQS queues #
######################################
# Wiz consumes new-log-file notifications from this queue; failed messages go to the DLQ.
module "organisation_cloudtrail_wiz_sqs" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "5.2.2"

  name                       = local.organisation_cloudtrail_wiz_queue
  kms_master_key_id          = module.organisation_cloudtrail_kms.key_arn
  sqs_managed_sse_enabled    = false
  visibility_timeout_seconds = local.organisation_cloudtrail_sqs_visibility_seconds
  message_retention_seconds  = local.organisation_cloudtrail_sqs_retention_seconds

  create_dlq                    = true
  dlq_name                      = local.organisation_cloudtrail_wiz_dlq
  dlq_kms_master_key_id         = module.organisation_cloudtrail_kms.key_arn
  dlq_sqs_managed_sse_enabled   = false
  dlq_message_retention_seconds = local.organisation_cloudtrail_sqs_retention_seconds
  redrive_policy = {
    maxReceiveCount = local.organisation_cloudtrail_sqs_max_receive_count
  }

  create_queue_policy = true
  queue_policy_statements = {
    snsSend = {
      sid       = "SnsSend"
      actions   = ["sqs:SendMessage"]
      resources = [local.organisation_cloudtrail_wiz_queue_arn]

      principals = [{
        type        = "Service"
        identifiers = ["sns.amazonaws.com"]
      }]

      condition = [{
        test     = "ArnEquals"
        variable = "aws:SourceArn"
        values   = [local.organisation_cloudtrail_sns_topic_arn]
      }]
    }
    denyInsecureTransport = {
      sid       = "DenyInsecureTransport"
      effect    = "Deny"
      actions   = ["sqs:*"]
      resources = [local.organisation_cloudtrail_wiz_queue_arn]

      principals = [{
        type        = "AWS"
        identifiers = ["*"]
      }]

      condition = [{
        test     = "Bool"
        variable = "aws:SecureTransport"
        values   = ["false"]
      }]
    }
  }

  tags = local.organisation_cloudtrail_tags
}
