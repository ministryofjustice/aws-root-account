module "scim" {
  source              = "github.com/ministryofjustice/moj-terraform-scim-github"
  github_organisation = local.sso.github_organisation
  github_token        = sensitive(local.sso.aws_saml.github_token)
  sso_aws_region      = local.sso.region
  sso_email_suffix    = local.sso.email_suffix
  sso_scim_token      = sensitive(local.sso.aws_saml.sso_scim_token)
  sso_tenant_id       = sensitive(local.sso.aws_saml.sso_tenant_id)
}
