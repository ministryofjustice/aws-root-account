module "scim" {
  # tflint-ignore: terraform_module_pinned_source
  source                = "github.com/ministryofjustice/moj-terraform-scim-github"
  github_organisation   = local.sso.github_organisation
  github_token          = sensitive(local.sso.aws_saml.github_token)
  sso_aws_region        = local.sso.region
  sso_email_suffix      = local.sso.email_suffix
  sso_identity_store_id = local.sso_admin_identity_store_id
  not_dry_run           = true
}

module "entraid_scim" {
  source              = "github.com/ministryofjustice/moj-terraform-scim-entra-id"
  azure_tenant_id     = "your-tenant-id"
  azure_client_id     = "your-client-id"
  azure_client_secret = "your-client-secret"
}
