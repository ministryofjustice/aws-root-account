variable "wiz_enabled" {
  type        = bool
  default     = false
  description = "Enable the Wiz member-account trial after replacing the placeholder OU and populating the wiz_external_id secret."
}

variable "wiz_target_ou_ids" {
  type        = set(string)
  default     = ["placeholder OU"]
  description = "Trial OU IDs, including descendants. Replace the deliberately invalid placeholder before enabling."
}

# Populated out-of-band as {"external_id": "<External ID>", "role_arn": "<Wiz trust role ARN>"}.
# Only read while enabled: a secret without a value cannot be read.
data "aws_secretsmanager_secret_version" "wiz_external_id" {
  count     = var.wiz_enabled ? 1 : 0
  secret_id = "wiz_external_id"
}

locals {
  wiz_connector = var.wiz_enabled ? sensitive(jsondecode(data.aws_secretsmanager_secret_version.wiz_external_id[0].secret_string)) : null
}

module "wiz_stackset" {
  source = "../../modules/wiz-stackset"
  count  = var.wiz_enabled ? 1 : 0

  wiz_role_arn      = local.wiz_connector.role_arn
  wiz_external_id   = local.wiz_connector.external_id
  wiz_target_ou_ids = var.wiz_target_ou_ids
  wiz_tags          = local.tags_organisation_management
}

output "wiz_stackset_id" {
  value       = one(module.wiz_stackset[*].wiz_stackset_id)
  description = "Wiz StackSet identifier; null while the trial is disabled. Check individual stack instance health separately."
}
