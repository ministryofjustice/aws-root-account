module "sso" {
  # tflint-ignore: terraform_module_pinned_source
  source                            = "github.com/ministryofjustice/moj-terraform-aws-sso?ref=79910dbc9771d24bfec4e255a13545d591def68f" # v3.4.2
  auth0_allowed_domains             = local.sso.email_suffix
  auth0_aws_sso_acs_url             = sensitive(local.sso.aws_saml.acs_url)
  auth0_aws_sso_issuer_url          = sensitive(local.sso.aws_saml.issuer_url)
  auth0_client_id                   = sensitive(local.sso.auth0_saml.client_id)
  auth0_client_secret               = sensitive(local.sso.auth0_saml.client_secret)
  auth0_github_allowed_orgs         = [local.sso.github_organisation]
  auth0_github_client_id            = sensitive(local.sso.github_saml.client_id)
  auth0_github_client_secret        = sensitive(local.sso.github_saml.client_secret)
  auth0_tenant_domain               = sensitive(local.sso.auth0_tenant_domain)
  auth0_azure_entraid_client_id     = sensitive(local.sso.azure_entraid_oidc.client_id)
  auth0_azure_entraid_client_secret = sensitive(local.sso.azure_entraid_oidc.client_secret)
  auth0_azure_entraid_domain        = sensitive(local.sso.azure_entraid_oidc.domain)
}
