######################################
# Organisation CloudTrail SNS topic  #
######################################
# Fans out new-log-file notifications from the organisation CloudTrail bucket.
module "organisation_cloudtrail_sns" {
  source  = "terraform-aws-modules/sns/aws"
  version = "7.2.0"

  name                        = local.organisation_cloudtrail_sns_topic
  kms_master_key_id           = module.organisation_cloudtrail_kms.key_arn
  enable_default_topic_policy = false

  topic_policy_statements = {
    s3Publish = {
      sid       = "S3Publish"
      actions   = ["sns:Publish"]
      resources = [local.organisation_cloudtrail_sns_topic_arn]

      principals = [{
        type        = "Service"
        identifiers = ["s3.amazonaws.com"]
      }]

      condition = [
        {
          test     = "ArnEquals"
          variable = "aws:SourceArn"
          values   = [local.organisation_cloudtrail_bucket_arn]
        },
        {
          test     = "StringEquals"
          variable = "aws:SourceAccount"
          values   = [data.aws_caller_identity.current.account_id]
        }
      ]
    }
    denyInsecureTransport = {
      sid       = "DenyInsecureTransport"
      effect    = "Deny"
      actions   = ["sns:Publish"]
      resources = [local.organisation_cloudtrail_sns_topic_arn]

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

  # Raw delivery, so the queue receives the S3 event rather than an SNS envelope.
  subscriptions = {
    wiz = {
      protocol             = "sqs"
      endpoint             = module.organisation_cloudtrail_wiz_sqs.queue_arn
      raw_message_delivery = true
    }
  }

  tags = local.organisation_cloudtrail_tags
}
