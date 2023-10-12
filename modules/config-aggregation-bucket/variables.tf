variable "tags" {
  description = "Tags to use for resources, where applicable"
  type        = map(any)
}

variable "enrolled_account_ids" {
  description = "Account IDs that require access to s3:PutObject in the S3 bucket (defaults to [])"
  type        = list(string)
  default     = []
}

variable "bucket_prefix" {
  description = "Bucket prefix to use for S3"
  type        = string
}
