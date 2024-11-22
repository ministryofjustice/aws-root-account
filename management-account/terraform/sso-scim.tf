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
  # tflint-ignore: terraform_module_pinned_source
  source              = "github.com/ministryofjustice/moj-terraform-scim-entra-id"
  azure_tenant_id     = sensitive(local.azure.tenant_id)
  azure_client_id     = sensitive(local.azure.client_id)
  azure_client_secret = sensitive(local.azure.client_secret)
}

module "aws_sso_entraid_integration_scim" {
  source = "github.com/ministryofjustice/moj-terraform-scim-entra-id"
  # tflint-ignore: terraform_module_pinned_source
  azure_tenant_id     = jsondecode(data.aws_secretsmanager_secret_version.aws_sso_entraid_integration.secret_string)["tenant_id"]
  azure_client_id     = jsondecode(data.aws_secretsmanager_secret_version.aws_sso_entraid_integration.secret_string)["client_id"]
  azure_client_secret = jsondecode(data.aws_secretsmanager_secret_version.aws_sso_entraid_integration.secret_string)["client_secret"]
}
