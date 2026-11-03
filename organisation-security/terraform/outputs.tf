# Organisation CloudTrail: inputs for the Wiz CloudTrail connector
output "organisation_cloudtrail_bucket_name" {
  value       = module.organisation_cloudtrail_s3_bucket.s3_bucket_id
  description = "S3 bucket receiving organisation CloudTrail log files"
}

output "organisation_cloudtrail_wiz_queue_url" {
  value       = module.organisation_cloudtrail_wiz_sqs.queue_url
  description = "SQS queue Wiz reads new-log-file notifications from"
}

output "organisation_cloudtrail_sns_topic_arn" {
  value       = module.organisation_cloudtrail_sns.topic_arn
  description = "SNS topic receiving the bucket's new-log-file notifications"
}

output "organisation_cloudtrail_arn" {
  value       = aws_cloudtrail.organisation.arn
  description = "Organisation CloudTrail ARN"
}
