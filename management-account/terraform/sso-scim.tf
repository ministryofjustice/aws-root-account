module "scim" {
  # tflint-ignore: terraform_module_pinned_source
  source                     = "github.com/ministryofjustice/moj-terraform-scim-github?ref=208f6d133cd0e2c19c582dff364d48011f15c5e8" # v2.0.1
  github_organisation        = local.sso.github_organisation
  github_app_id              = sensitive(local.sso.aws_saml.github_app_id)
  github_app_private_key     = sensitive(local.sso.aws_saml.github_app_private_key)
  github_app_installation_id = sensitive(local.sso.aws_saml.github_app_installation_id)
  sso_aws_region             = local.sso.region
  sso_email_suffix           = local.sso.email_suffix
  sso_identity_store_id      = local.sso_admin_identity_store_id
  not_dry_run                = true
}

module "entraid_scim" {
  # tflint-ignore: terraform_module_pinned_source
  source              = "github.com/ministryofjustice/moj-terraform-scim-entra-id?ref=61ed386f4d5cd07d3411c73e1bd2f790224c4964" # v1.0.0
  azure_tenant_id     = sensitive(local.azure.tenant_id)
  azure_client_id     = sensitive(local.azure.client_id)
  azure_client_secret = sensitive(local.azure.client_secret)
}
