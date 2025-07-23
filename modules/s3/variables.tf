variable "bucket_name" {
  type    = string
  default = null
}

variable "bucket_prefix" {
  type    = string
  default = null
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "bucket_acl" {
  type    = string
  default = "private"
}

variable "attach_policy" {
  type    = bool
  default = false
}

variable "policy" {
  type    = string
  default = ""
}

variable "enable_versioning" {
  type    = bool
  default = true
}

variable "block_public_acls" {
  type    = bool
  default = true
}

variable "block_public_policy" {
  type    = bool
  default = true
}

variable "ignore_public_acls" {
  type    = bool
  default = true
}

variable "restrict_public_buckets" {
  type    = bool
  default = true
}

variable "server_side_encryption_configuration" {
  type    = any
  default = {}
}

variable "additional_tags" {
  type    = map(any)
  default = {}
}

variable "require_ssl_requests" {
  type    = bool
  default = false
}

variable "object_ownership" {
  type    = string
  default = "BucketOwnerEnforced"
}

variable "object_lock_enabled" {
  type    = bool
  default = false
}

variable "object_lock_retention" {
  type    = any
  default = {}
}

variable "enable_replication" {
  description = "Whether to enable cross-account replication"
  type        = bool
  default     = false
}

variable "replication_bucket_arn" {
  description = "ARN of the destination bucket for replication"
  type        = string
  default     = ""
}

variable "replication_role_arn" {
  description = "ARN of the IAM role for S3 replication"
  type        = string
  default     = ""
}

variable "replication_rules" {
  description = "Replication rules for the bucket"
  type = list(object({
    id                    = string
    prefix                = string
    status                = string
    deletemarker          = string
    replica_kms_key_id    = string
    metrics               = string
    kms_encrypted_objects = string
  }))
  default = []
}

variable "source_kms_arn" {
  description = "ARN of source bucket KMS key"
  type        = string
  default     = ""
}

variable "destination_kms_arn" {
  description = "ARN of destination bucket KMS key"
  type        = string
  default     = ""
}

