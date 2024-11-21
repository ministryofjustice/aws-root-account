# Email addresses for AWS accounts
# There is a manually added "template" key for templating email addresses for new accounts configured in this account,
# so you can do:
# `email = replace(local.aws_account_email_addresses_template, "{email}", "account-name")`
# Accounts that were configured before this can use:
# `email = local.aws_account_email_addresses["account-name"][0]`

data "aws_secretsmanager_secret_version" "azure_entraid_oidc" {
  secret_id = aws_secretsmanager_secret.azure_entraid_oidc.id
}

# Retrieving existing secret

data "aws_secretsmanager_secret" "azure_aws_connectivity_details" {
  name = "entra_id_aws_connectivity_details"
}

data "aws_secretsmanager_secret_version" "azure_aws_connectivity_details" {
  secret_id = data.aws_secretsmanager_secret.azure_aws_connectivity_details.id
}
