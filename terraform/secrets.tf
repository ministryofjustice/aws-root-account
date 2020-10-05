# SAML: Auth0 credentials
resource "aws_secretsmanager_secret" "auth0_saml" {
  name        = "auth0_saml"
  description = "Auth0 Machine to Machine credentials for Terraform to setup Auth0 for AWS SSO"
  tags        = local.root_account
}

data "aws_secretsmanager_secret_version" "auth0_saml" {
  secret_id = aws_secretsmanager_secret.auth0_saml.id
}

# SAML: GitHub client ID and secrets
resource "aws_secretsmanager_secret" "github_saml" {
  name        = "github_saml"
  description = "GitHub client ID and secret for the Ministry of Justice owned OAuth app for AWS SSO"
  tags        = local.root_account
}

data "aws_secretsmanager_secret_version" "github_saml" {
  secret_id = aws_secretsmanager_secret.github_saml.id
}

# SAML: AWS SSO
resource "aws_secretsmanager_secret" "aws_saml" {
  name        = "aws_saml"
  description = "AWS SSO ACS and Issuer URLs"
  tags        = local.root_account
}

data "aws_secretsmanager_secret_version" "aws_saml" {
  secret_id = aws_secretsmanager_secret.aws_saml.id
}

locals {
  auth0_saml  = jsondecode(data.aws_secretsmanager_secret_version.auth0_saml.secret_string)
  github_saml = jsondecode(data.aws_secretsmanager_secret_version.github_saml.secret_string)
  aws_saml    = jsondecode(data.aws_secretsmanager_secret_version.aws_saml.secret_string)
}
