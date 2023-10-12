variable "s3_bucket_arn" {
  description = "S3 bucket ARN to give access to"
  type        = string
}

variable "sns_topic_arns" {
  description = "SNS topic ARNs to give access to"
  type        = list(string)
}
