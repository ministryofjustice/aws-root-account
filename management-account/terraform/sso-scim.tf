module "scim" {
  # tflint-ignore: terraform_module_pinned_source
  source                = "github.com/ministryofjustice/moj-terraform-scim-github?ref=52a981e832f47fd75f023c647913ca1a8d9ac907"
  github_organisation   = local.sso.github_organisation
  github_token          = sensitive(local.sso.aws_saml.github_token)
  sso_aws_region        = local.sso.region
  sso_email_suffix      = local.sso.email_suffix
  sso_identity_store_id = local.sso_admin_identity_store_id
  not_dry_run           = true
}

module "entraid_scim" {
  # tflint-ignore: terraform_module_pinned_source
  source              = "github.com/ministryofjustice/moj-terraform-scim-entra-id?ref=61ed386f4d5cd07d3411c73e1bd2f790224c4964"
  azure_tenant_id     = sensitive(local.azure.tenant_id)
  azure_client_id     = sensitive(local.azure.client_id)
  azure_client_secret = sensitive(local.azure.client_secret)
}
