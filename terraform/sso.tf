locals {
  email_suffix        = "@digital.justice.gov.uk"
  sso_region          = "eu-west-2"
  github_organisation = "ministryofjustice"
  auth0_tenant_domain = "ministryofjustice.eu.auth0.com"
}

module "sso" {
  source                     = "github.com/ministryofjustice/moj-terraform-aws-sso?ref=af6f4debb6d8473a73f2f82c6c5bcad431e1059c" #v1.0.0"
  auth0_allowed_domains      = local.email_suffix
  auth0_aws_sso_acs_url      = local.aws_saml.acs_url    # Note that this is a secret, but is output in plaintext when using `terraform plan` or `terraform apply`
  auth0_aws_sso_issuer_url   = local.aws_saml.issuer_url # Note that this is a secret, but is output in plaintext when using `terraform plan` or `terraform apply`
  auth0_client_id            = local.auth0_saml.client_id
  auth0_client_secret        = local.auth0_saml.client_secret
  auth0_github_allowed_orgs  = [local.github_organisation]
  auth0_github_client_id     = local.github_saml.client_id
  auth0_github_client_secret = local.github_saml.client_secret
  auth0_tenant_domain        = local.auth0_tenant_domain
  sso_aws_region             = local.sso_region
  sso_scim_token             = local.aws_saml.sso_scim_token # Note that this is a secret, but is output in plaintext when using `terraform plan` or `terraform apply`
  sso_tenant_id              = local.aws_saml.sso_tenant_id  # Note that this is a secret, but is output in plaintext when using `terraform plan` or `terraform apply`
}

module "scim" {
  source              = "github.com/ministryofjustice/moj-terraform-scim-github"
  github_organisation = local.github_organisation
  github_token        = local.aws_saml.github_token # Note that this is a secret, but is output in plaintext when using `terraform plan` or `terraform apply`
  sso_aws_region      = local.sso_region
  sso_email_suffix    = local.email_suffix
  sso_scim_token      = local.aws_saml.sso_scim_token # Note that this is a secret, but is output in plaintext when using `terraform plan` or `terraform apply`
  sso_tenant_id       = local.aws_saml.sso_tenant_id  # Note that this is a secret, but is output in plaintext when using `terraform plan` or `terraform apply`
}
