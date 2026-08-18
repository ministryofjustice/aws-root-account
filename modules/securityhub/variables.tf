variable "is_delegated_administrator" {
  type    = bool
  default = false
}

variable "aggregation_region" {
  type    = bool
  default = false
}

variable "admin_account" {
  type    = string
  default = null
}

variable "enrolled_accounts" {
  type    = map(any)
  default = {}
}

variable "opg_config_1_suppress_account_ids" {
  description = "OPG account IDs for which Config.1 findings are suppressed outside the active regions."
  type        = list(string)
  default     = []
}
