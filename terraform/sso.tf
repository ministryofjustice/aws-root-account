module "sso" {
  source                     = "github.com/ministryofjustice/moj-terraform-aws-sso"
  auth0_tenant_domain        = "ministryofjustice.eu.auth0.com"
  auth0_client_id            = local.auth0_saml.client_id
  auth0_client_secret        = local.auth0_saml.client_secret
  auth0_github_client_id     = local.github_saml.client_id
  auth0_github_client_secret = local.github_saml.client_secret
  auth0_aws_sso_acs_url      = local.aws_saml.acs_url
  auth0_aws_sso_issuer_url   = local.aws_saml.issuer_url
  auth0_github_allowed_orgs  = ["ministryofjustice"]
  auth0_allowed_domains      = ["justice.gov.uk", "digital.justice.gov.uk"]
}
