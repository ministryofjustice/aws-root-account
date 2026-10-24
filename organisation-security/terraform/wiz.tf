variable "wiz_enabled" {
  type        = bool
  default     = false
  description = "Enable the Wiz member-account trial after replacing the placeholder OU and supplying connector settings."
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

variable "wiz_target_ou_ids" {
  type        = set(string)
  default     = ["placeholder OU"]
  description = "Trial OU IDs, including descendants. Replace the deliberately invalid placeholder before enabling."
}

module "wiz_stackset" {
  source = "../../modules/wiz-stackset"
  count  = var.wiz_enabled ? 1 : 0

  wiz_role_arn      = var.wiz_trust_role_arn
  wiz_external_id   = var.wiz_external_id
  wiz_target_ou_ids = var.wiz_target_ou_ids
  wiz_tags          = local.tags_organisation_management
}

output "wiz_stackset_id" {
  value       = one(module.wiz_stackset[*].wiz_stackset_id)
  description = "Wiz StackSet identifier; null while the trial is disabled. Check individual stack instance health separately."
}
