variable "kms_key_arn" {
  description = "KMS key ARN for encrypting GuardDuty findings in S3"
  type        = string
}

variable "destination_arn" {
  description = "S3 bucket ARN where findings get exported to"
  type        = string
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

variable "threatintelset_bucket" {
  description = "GuardDuty ThreatIntelSet bucket"
  type        = string
}

variable "threatintelset_key" {
  description = "GuardDuty ThreatIntelSet key"
  type        = string
}

variable "enable_threatintelset" {
  description = "Whether to enable a ThreatIntelSet for GuardDuty"
  type        = bool
  default     = false
}

variable "enable_guardduty_detector" {
  description = "Whether to enable GuardDuty Detector"
  type        = bool
  default     = false
}

variable "administrator_detector_id" {
  description = "Guardduty detector ID of the region administrator"
  type        = string
}
