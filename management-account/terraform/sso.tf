module "sso" {
  # tflint-ignore: terraform_module_pinned_source
  source                            = "github.com/ministryofjustice/moj-terraform-aws-sso?ref=e7054eb43a3c956ab179c55369f278e06c428c2d" # TODO: replace with release tag once ministryofjustice/moj-terraform-aws-sso#79 is merged
  auth0_allowed_domains             = local.sso.email_suffix
  auth0_aws_sso_acs_urls            = sensitive(local.sso.aws_saml.acs_urls)
  auth0_client_id                   = sensitive(local.sso.auth0_saml.client_id)
  auth0_client_secret               = sensitive(local.sso.auth0_saml.client_secret)
  auth0_github_allowed_orgs         = [local.sso.github_organisation]
  auth0_github_client_id            = sensitive(local.sso.github_saml.client_id)
  auth0_github_client_secret        = sensitive(local.sso.github_saml.client_secret)
  auth0_tenant_domain               = sensitive(local.sso.auth0_tenant_domain)
  auth0_azure_entraid_client_id     = sensitive(local.sso.azure_entraid_oidc.client_id)
  auth0_azure_entraid_client_secret = sensitive(local.sso.azure_entraid_oidc.client_secret)
  auth0_azure_entraid_domain        = sensitive(local.sso.azure_entraid_oidc.domain)
  github_app_id                     = sensitive(local.sso.aws_saml.github_app_id)
  github_app_installation_id        = sensitive(local.sso.aws_saml.github_app_installation_id)
  github_app_private_key            = sensitive(data.aws_secretsmanager_secret_version.github_app_private_key.secret_string)
  github_via_entraid                = "created"
}
