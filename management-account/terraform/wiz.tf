variable "wiz_enabled" {
  type        = bool
  default     = false
  description = "Enable the Wiz management-account trial after reviewing the plan and supplying connector settings."
}

variable "wiz_trust_role_arn" {
  type        = string
  default     = ""
  description = "Wiz tenant/data-centre trust role ARN from the connector settings; required when wiz_enabled is true."
}

variable "wiz_external_id" {
  type        = string
  default     = ""
  sensitive   = true
  description = "External ID supplied by the Wiz connector; required when wiz_enabled is true."
}

module "wiz_management" {
  source = "../../modules/wiz-management"
  count  = var.wiz_enabled ? 1 : 0

  wiz_management_account_id = aws_organizations_organization.default.master_account_id
  wiz_trust_role_arn        = var.wiz_trust_role_arn
  wiz_external_id           = var.wiz_external_id
  wiz_tags                  = local.tags_organisation_management
}

output "wiz_management_role_arn" {
  value       = one(module.wiz_management[*].wiz_management_role_arn)
  description = "Management-account role ARN for the Wiz connector; null while the trial is disabled."
}
