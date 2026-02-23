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

variable "modernisation_platform_account_id" {
  description = "Account ID of the Modernisation Platform delegated admin account"
  type        = string
}
