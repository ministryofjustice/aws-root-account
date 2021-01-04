variable "s3_bucket_name" {
  description = "S3 bucket name to deliver resource changes to"
  type        = string
}

variable "sns_topic_arn" {
  description = "SNS topic ARN to deliver resource changes to"
  type        = string
}

variable "iam_role_arn" {
  description = "IAM role ARN for an IAM role with Config permissions"
  type        = string
}

variable "home_region" {
  default     = "eu-west-2"
  description = "Which region to use to record global resources (defaults to eu-west-2)"
  type        = string
}
