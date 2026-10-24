variable "wiz_enabled" {
  type        = bool
  default     = false
  description = "Enable the Wiz management-account trial after reviewing the plan and populating the wiz_external_id secret."
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

module "wiz_management" {
  source = "../../modules/wiz-management"
  count  = var.wiz_enabled ? 1 : 0

  wiz_management_account_id = aws_organizations_organization.default.master_account_id
  wiz_trust_role_arn        = local.wiz_connector.role_arn
  wiz_external_id           = local.wiz_connector.external_id
  wiz_tags                  = local.tags_organisation_management
}

output "wiz_management_role_arn" {
  value       = one(module.wiz_management[*].wiz_management_role_arn)
  description = "Management-account role ARN for the Wiz connector; null while the trial is disabled."
}
