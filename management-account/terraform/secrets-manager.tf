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
