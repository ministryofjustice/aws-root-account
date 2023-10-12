variable "create_iam_role" {
  type        = bool
  description = "Whether to create the IAM role for AWS Config"
  default     = false
}

variable "iam_role_arn" {
  type        = string
  description = "IAM role ARN for AWS Config, if create_iam_role is set to false"
  default     = ""
}

variable "s3_bucket_name" {
  type        = string
  description = "S3 bucket name for AWS Config logs"
}

variable "sns_topic_arn" {
  description = "SNS topic ARN to deliver resource changes to"
  type        = string
  default     = null
}

variable "home_region" {
  default     = "eu-west-2"
  description = "Which region to use to record global resources (defaults to eu-west-2)"
  type        = string
}

variable "snapshot_delivery_frequency" {
  default     = "TwentyFour_Hours"
  description = "Delivery channel snapshot delivery frequency"
  type        = string
}
