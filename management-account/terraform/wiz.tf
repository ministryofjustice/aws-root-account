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

# Wiz's own module. The checksum pins the reviewed archive; init fails if it changes.
module "wiz" {
  source = "https://wizio-public.s3.amazonaws.com/deployment-v3/aws/terraform/2796/wiz-aws-native-terraform-terraform-module.zip?checksum=sha256:ada51284d49dd3e6e2f1862385acd725dbadec693335b5af4f458763b21fbd06"
  count  = local.wiz_enabled ? 1 : 0

  external-id = local.wiz_connector.external_id
  remote-arn  = local.wiz_connector.role_arn
  tags        = local.tags_organisation_management

  # Every feature switch is set explicitly rather than relying on Wiz's defaults.
  cloud-cost-scanning       = false
  data-scanning             = false
  eks-scanning              = false
  lightsail-scanning        = false
  s3-inventory-scanning     = true
  terraform-bucket-scanning = true
  wiz-defend-awslogs-policy = true
  wiz-defend-rds-policy     = true
  wiz-defend-s3-kms-policy  = true
}

# The role was first applied through the removed modules/wiz-management wrapper.
moved {
  from = module.wiz_management[0].module.vendor
  to   = module.wiz[0]
}

output "wiz_management_role_arn" {
  value       = one(module.wiz[*].role_arn)
  description = "Management-account role ARN for the Wiz connector; null while disabled."
}
