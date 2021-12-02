variable "enrolled_into_securityhub" {
  description = "Map of key => values where key is the account name and the value is the account ID"
  type        = map(any)
  default     = {}
}

variable "aggregation_region" {
  description = "Whether to use this region for all region aggregation"
  type        = bool
  default     = false
}
