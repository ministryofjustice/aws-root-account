# Email addresses for AWS accounts
# There is a manually added "template" key for templating email addresses for new accounts configured in this account,
# so you can do:
# `email = replace(local.aws_account_email_addresses_template, "{email}", "account-name")`
# Accounts that were configured before this can use:
# `email = local.aws_account_email_addresses["account-name"][0]`
resource "aws_secretsmanager_secret" "aws_account_email_addresses" {
  name        = "aws_account_email_addresses"
  description = "Email addresses for AWS accounts in AWS Organizations"
  tags        = local.root_account
}

# We can get all account emails to update the secret, regardless of if they're in Terraform or clickopsed;
# and keep the list up to date with (new) templated email addresses.
data "aws_organizations_organization" "root" {}

locals {
  configured_aws_account_email_addresses = {
    for account in data.aws_organizations_organization.root.accounts :
    account.name => account.email...
  }
}

resource "aws_secretsmanager_secret_version" "aws_account_email_addresses" {
  secret_id = aws_secretsmanager_secret.aws_account_email_addresses.id
  secret_string = jsonencode(
    merge(
      local.configured_aws_account_email_addresses,
      local.aws_account_email_addresses
    )
  )
}

data "aws_secretsmanager_secret_version" "aws_account_email_addresses" {
  secret_id = aws_secretsmanager_secret.aws_account_email_addresses.id
}

locals {
  aws_account_email_addresses          = jsondecode(data.aws_secretsmanager_secret_version.aws_account_email_addresses.secret_string)
  aws_account_email_addresses_template = local.aws_account_email_addresses["template"]
}

# SAML: Auth0 credentials
resource "aws_secretsmanager_secret" "auth0_saml" {
  name        = "auth0_saml"
  description = "Auth0 Machine to Machine credentials for Terraform to setup Auth0 for AWS SSO"
}

data "aws_secretsmanager_secret_version" "auth0_saml" {
  secret_id = aws_secretsmanager_secret.auth0_saml.id
}

# SAML: GitHub client ID and secrets
resource "aws_secretsmanager_secret" "github_saml" {
  name        = "github_saml"
  description = "GitHub client ID and secret for the Ministry of Justice owned OAuth app for AWS SSO"
}

data "aws_secretsmanager_secret_version" "github_saml" {
  secret_id = aws_secretsmanager_secret.github_saml.id
}

# SAML: AWS SSO
resource "aws_secretsmanager_secret" "aws_saml" {
  name        = "aws_saml"
  description = "AWS SSO ACS and Issuer URLs"
}

data "aws_secretsmanager_secret_version" "aws_saml" {
  secret_id = aws_secretsmanager_secret.aws_saml.id
}

# GitHub App Private Key for SCIM
resource "aws_secretsmanager_secret" "github_app_private_key" {
  name        = "github_app_private_key"
  description = "GitHub App private key for AWS SSO SCIM provisioning"
}

data "aws_secretsmanager_secret_version" "github_app_private_key" {
  secret_id = aws_secretsmanager_secret.github_app_private_key.id
}

# OIDC: Azure EntraID client ID and secrets
resource "aws_secretsmanager_secret" "azure_entraid_oidc" {
  name        = "azure_entraid_oidc"
  description = "Azure client ID and secret for the Ministry of Justice owned OAuth app for AWS SSO"
}

# Importing existing secret
import {
  to = aws_secretsmanager_secret.azure_entraid_oidc
  id = "arn:aws:secretsmanager:eu-west-2:${data.aws_caller_identity.current.account_id}:secret:azure_entraid_oidc-tivo7F"
}

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

# LAA-Specific Secrets

resource "aws_secretsmanager_secret" "laa_lz_data_locations" {
  name        = "laa-landing-zone-data-locations"
  description = "LAA Landing Zone Data Locations"
}

resource "aws_secretsmanager_secret_version" "laa_lz_data_locations" {
  secret_id = aws_secretsmanager_secret.laa_lz_data_locations.id
  secret_string = jsonencode({
    locations = [
      "dummy"
    ]
  })

  lifecycle {
    ignore_changes = [
      secret_string
    ]
  }
}

# Retrieving LAA Existing Secret

data "aws_secretsmanager_secret" "laa_lz_data_locations" {
  name = "laa-landing-zone-data-locations"
}

data "aws_secretsmanager_secret_version" "laa_lz_data_locations_version" {
  secret_id = data.aws_secretsmanager_secret.laa_lz_data_locations.id
}
