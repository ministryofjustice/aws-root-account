locals {
  wiz_enabled      = true
  wiz_excluded_ous = [local.ou_opg]

  # Every top-level OU except excluded ones. StackSets also deploy to
  # descendant OUs and to accounts that later join any targeted OU.
  wiz_target_ou_ids = [
    for ou in data.aws_organizations_organizational_units.organizational_units.children : ou.id
    if !contains(local.wiz_excluded_ous, ou.id)
  ]
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

  # Deploy to 25 accounts at once; stop after more than 5 failures.
  wiz_concurrency_mode        = "SOFT_FAILURE_TOLERANCE"
  wiz_max_concurrent_count    = 50
  wiz_failure_tolerance_count = 15

  wiz_template_parameters = {
    CloudCostScanning       = "Enabled"
    DataScanning            = "Disabled"
    EKSScanning             = "Disabled"
    LightsailScanning       = "Disabled"
    RDSLogsScanning         = "Enabled"
    S3AWSLogsScanning       = "Enabled"
    S3InventoryScanning     = "Enabled"
    S3KMSDecrypt            = "Enabled"
    TerraformBucketScanning = "Enabled"
  }
}

output "wiz_stackset_id" {
  value       = one(module.wiz_stackset[*].wiz_stackset_id)
  description = "Wiz StackSet identifier; null while the trial is disabled. Check individual stack instance health separately."
}
