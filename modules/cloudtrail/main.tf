##############
# CloudTrail #
##############
resource "aws_cloudtrail" "default" {
  name           = "cloudtrail"
  s3_bucket_name = var.bucket_name

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail.arn
  enable_log_file_validation = true
  enable_logging             = true

  event_selector {
    exclude_management_event_sources = []
    include_management_events        = true
    read_write_type                  = "All"

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3"]
    }

    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
    }

    data_resource {
      type   = "AWS::DynamoDB::Table"
      values = ["arn:aws:dynamodb"]
    }
  }

  include_global_service_events = true
  is_multi_region_trail         = true
  is_organization_trail         = false

  kms_key_id     = aws_kms_key.cloudtrail.arn
  sns_topic_name = trimprefix(aws_sns_topic.cloudtrail.arn, "arn:aws:sns:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:")
}
