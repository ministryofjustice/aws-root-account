######################################################################################
# CommonFate is currently being used as a proof-of-concept by the Data Platform team #
# Last updated: 2023-03-19                                                           #
######################################################################################
data "aws_region" "current" {}

data "aws_identitystore_group" "commonfate_administrators" {
  identity_store_id = local.sso_admin_identity_store_id

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = "common-fate-administrators"
    }
  }
}

# This secret was manually created due to a race condition.
data "aws_secretsmanager_secret" "commonfate_saml_application_metadata_url" {
  name = "commonfate-saml-application-metadata-url"
}

data "aws_secretsmanager_secret_version" "commonfate_saml_application_metadata_url" {
  secret_id = data.aws_secretsmanager_secret.commonfate_saml_application_metadata_url.id
}

data "aws_secretsmanager_secret" "commonfate_slack_webhook_url" {
  name = "commonfate-slack-webhook-url"
}

data "aws_secretsmanager_secret_version" "commonfate_slack_webhook_url" {
  secret_id = data.aws_secretsmanager_secret.commonfate_slack_webhook_url.id
}

module "commonfate" {
  # Commenting out while we test Slack integration
  # source  = "bjsscloud/common-fate/aws"
  # version = "2.1.0"
  source = "github.com/bjsscloud/terraform-aws-common-fate?ref=slack-incoming-webhooks"

  providers = {
    aws           = aws
    aws.us-east-1 = aws.us-east-1
  }

  project     = "moj"
  environment = "prod"
  component   = "sso"

  aws_account_id = data.aws_caller_identity.current.account_id
  region         = data.aws_region.current.name

  public_hosted_zone_id = aws_route53_zone.access_platforms_service_justice_gov_uk.zone_id

  aws_sso_identity_store_id = local.sso_admin_identity_store_id
  aws_sso_instance_arn      = local.sso_admin_instance_arn
  aws_sso_region            = data.aws_region.current.name

  sources_version = "v0.14.7"

  identity_provider_type = "aws-sso"
  identity_provider_name = "AWS"
  administrator_group_id = data.aws_identitystore_group.commonfate_administrators.id

  saml_sso_metadata_url = data.aws_secretsmanager_secret_version.commonfate_saml_application_metadata_url.secret_string

  slack_incoming_webhook_urls = {
    common-fate-requests = data.aws_secretsmanager_secret_version.commonfate_slack_webhook_url.secret_string
  }
}
