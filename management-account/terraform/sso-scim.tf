module "scim" {
  source                = "github.com/ministryofjustice/moj-terraform-scim-github"
  github_organisation   = local.sso.github_organisation
  github_token          = sensitive(local.sso.aws_saml.github_token)
  sso_aws_region        = local.sso.region
  sso_email_suffix      = local.sso.email_suffix
  sso_identity_store_id = local.sso_admin_identity_store_id
}
