locals {
  wiz_enabled       = false
  wiz_target_ou_ids = ["placeholder OU"]
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

module "wiz_stackset" {
  source = "../../modules/wiz-stackset"
  count  = local.wiz_enabled ? 1 : 0

  wiz_role_arn      = local.wiz_connector.role_arn
  wiz_external_id   = local.wiz_connector.external_id
  wiz_target_ou_ids = local.wiz_connector == null ? null : local.wiz_target_ou_ids
  wiz_tags          = local.tags_organisation_management
}

output "wiz_stackset_id" {
  value       = one(module.wiz_stackset[*].wiz_stackset_id)
  description = "Wiz StackSet identifier; null while the trial is disabled. Check individual stack instance health separately."
}
