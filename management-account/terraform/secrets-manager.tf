data "aws_secretsmanager_secret" "aws_account_email_addresses" {
  name = "aws_account_email_addresses"
}

data "aws_secretsmanager_secret_version" "aws_account_email_addresses" {
  secret_id = data.aws_secretsmanager_secret.aws_account_email_addresses.id
}

locals {
  aws_account_email_addresses          = jsondecode(data.aws_secretsmanager_secret_version.aws_account_email_addresses.secret_string)
  aws_account_email_addresses_template = local.aws_account_email_addresses["template"]
}

# Below is a data source to get all Modernisation Platform-managed AWS accounts
data "aws_secretsmanager_secret" "modernisation_platform_environment_management" {
  provider = aws.modernisation-platform
  name     = "environment_management"
}

data "aws_secretsmanager_secret_version" "modernisation_platform_account_ids" {
  provider  = aws.modernisation-platform
  secret_id = data.aws_secretsmanager_secret.modernisation_platform_environment_management.id
}

locals {
  modernisation_platform_environment_management = jsondecode(data.aws_secretsmanager_secret_version.modernisation_platform_account_ids.secret_string).account_ids
}
