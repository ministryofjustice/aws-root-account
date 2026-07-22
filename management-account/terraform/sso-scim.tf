module "scim" {
  # tflint-ignore: terraform_module_pinned_source
  source                     = "github.com/ministryofjustice/moj-terraform-scim-github?ref=31304be39b8e7c15f17131be8b1648b01ce8a608" # v3.6.1
  github_organisation        = local.sso.github_organisation
  github_app_id              = sensitive(local.sso.aws_saml.github_app_id)
  github_app_installation_id = sensitive(local.sso.aws_saml.github_app_installation_id)
  github_app_private_key     = sensitive(data.aws_secretsmanager_secret_version.github_app_private_key.secret_string)
  sso_aws_region             = local.sso.region
  sso_email_suffix           = local.sso.email_suffix
  sso_identity_store_id      = local.sso_admin_identity_store_id
  not_dry_run                = true

  # Monitoring configuration
  enable_monitoring   = true
  alarm_sns_topic_arn = ""
}

module "entraid_scim" {
  # tflint-ignore: terraform_module_pinned_source
  source              = "github.com/ministryofjustice/moj-terraform-scim-entra-id?ref=d9411f9273c381a615d4017ffbde239ea37076d5" # v3.0.0
  azure_tenant_id     = sensitive(local.azure.tenant_id)
  azure_client_id     = sensitive(local.azure.client_id)
  azure_client_secret = sensitive(local.azure.client_secret)

  # Monitoring configuration
  enable_monitoring   = true
  alarm_sns_topic_arn = ""
}

module "scim_slack_notifications" {
  source = "github.com/ministryofjustice/modernisation-platform-terraform-aws-chatbot?ref=0ec33c7bfde5649af3c23d0834ea85c849edf3ac" # v3.0.0

  application_name = "scim-monitoring"
  slack_channel_id = "C02PFCG8M1R"
  sns_topic_arns = [
    module.entraid_scim.sns_topic_arn,
    module.scim.sns_topic_arn,
    aws_sns_topic.modernisation_platform_scp_change_alerts.arn
  ]
  tags = {}
}
