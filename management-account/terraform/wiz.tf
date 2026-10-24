locals {
  wiz_enabled = true
}

# Populated out-of-band as {"external_id": "<External ID>", "role_arn": "<Wiz trust role ARN>"}.
# Only read while enabled: a secret without a value cannot be read.
data "aws_secretsmanager_secret_version" "wiz_external_id" {
  count     = local.wiz_enabled ? 1 : 0
  secret_id = "wiz_external_id"
}

# Derived from the data source so module inputs stay unknown during validate and
# null while disabled; module inputs are only evaluated while enabled.
locals {
  wiz_secret    = one(data.aws_secretsmanager_secret_version.wiz_external_id[*].secret_string)
  wiz_connector = local.wiz_secret == null ? null : sensitive(jsondecode(local.wiz_secret))
}

module "wiz_management" {
  source = "../../modules/wiz-management"
  count  = local.wiz_enabled ? 1 : 0

  wiz_management_account_id = aws_organizations_organization.default.master_account_id
  wiz_trust_role_arn        = local.wiz_connector.role_arn
  wiz_external_id           = local.wiz_connector.external_id
  wiz_tags                  = local.tags_organisation_management
}

output "wiz_management_role_arn" {
  value       = one(module.wiz_management[*].wiz_management_role_arn)
  description = "Management-account role ARN for the Wiz connector; null while the trial is disabled."
}
