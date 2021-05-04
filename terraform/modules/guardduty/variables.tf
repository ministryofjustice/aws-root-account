variable "enrolled_into_guardduty" {
  description = "Map of key => values where key is the account name and the value is the account ID"
  type        = map(any)
  default     = {}
}

variable "kms_key_arn" {
  description = "KMS key ARN for encrypting GuardDuty findings in S3"
  type        = string
}

variable "destination_arn" {
  description = "S3 bucket ARN where findings get exported to"
  type        = string
}

variable "root_tags" {
  description = "Tags to apply to resources created in the root account, if applicable"
  type        = map(any)
  default     = {}
}

variable "administrator_tags" {
  description = "Tags to apply to resources created in the delegated administrator account, if applicable"
  type        = map(any)
  default     = {}
}

variable "filterable_security_accounts" {
  description = "Security account IDs to filter out (with NOOP)"
  type        = list(string)
  default     = []
}

variable "auto_enable" {
  description = "Whether to auto-enable GuardDuty in new AWS accounts"
  type        = bool
  default     = false
}
