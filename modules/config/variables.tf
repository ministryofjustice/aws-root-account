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
