# Accounts to attach from the AWS Organization
# This is currently done by adding accounts on a one-by-one basis as
# we need to onboard people singularly rather than all at once.
# In the future we can replace all of this with a for_each on a
# data.aws_organizations_organization.example.accounts[*].id data resource,
# and auto_enable will be turned on so new accounts won't need to be added here.
# Any account added here in the meanwhile will have GuardDuty enabled in:
# - eu-west-2 (guardduty.tf)
# - eu-west-1 (guardduty-eu-west-1.tf)
#
# The configuration for the publishing destination is in guardduty-publishing-destination.tf,
# which has an eu-west-2 bucket that all regional GuardDuty configurations publish to.

# resource "aws_organizations_account" "analytics-platform-development" {
# resource "aws_organizations_account" "analytical-platform-data-engineering" {
locals {
  enrolled_into_guardduty = concat([
    { id = local.caller_identity.account_id, name = "MoJ root account" },
    aws_organizations_account.analytical-platform-development,
    aws_organizations_account.analytical-platform-landing,
    aws_organizations_account.analytical-platform-production,
    aws_organizations_account.aws-laa,
    aws_organizations_account.bichard7-2020-prototype,
    aws_organizations_account.cica,
    aws_organizations_account.cica-development,
    aws_organizations_account.cica-test-verify,
    aws_organizations_account.cica-uat,
    aws_organizations_account.cloud-platform,
    aws_organizations_account.cloud-platform-ephemeral-test,
    aws_organizations_account.cloud-platform-transit-gateways,
    aws_organizations_account.electronic-monitoring-archive-query-service,
    aws_organizations_account.electronic-monitoring-identity-access-management,
    aws_organizations_account.electronic-monitoring-infrastructure-dev,
    aws_organizations_account.electronic-monitoring-monitoring-mapping-dev,
    aws_organizations_account.electronic-monitoring-monitoring-mapping-pre-prod,
    aws_organizations_account.electronic-monitoring-monitoring-mapping-prod,
    aws_organizations_account.electronic-monitoring-monitoring-mapping-test,
    aws_organizations_account.electronic-monitoring-protective-monitoring,
    aws_organizations_account.electronic-monitoring-shared-logging,
    aws_organizations_account.electronic-monitoring-shared-networking,
    aws_organizations_account.electronic-monitoring-shared-networking-non-prod,
    aws_organizations_account.electronic-monitoring-tagging-hardware-pre-prod,
    aws_organizations_account.electronic-monitoring-tagging-hardware-prod,
    aws_organizations_account.electronic-monitoring-tagging-hardware-test,
    aws_organizations_account.hmpps-dev,
    aws_organizations_account.hmpps-management,
    aws_organizations_account.hmpps-prod,
    aws_organizations_account.laa-cloudtrail,
    aws_organizations_account.laa-development,
    aws_organizations_account.laa-production,
    aws_organizations_account.laa-shared-services,
    aws_organizations_account.laa-staging,
    aws_organizations_account.laa-test,
    aws_organizations_account.laa-uat,
    aws_organizations_account.legal-aid-agency,
    aws_organizations_account.manchester-traffic-dev,
    aws_organizations_account.modernisation-platform,
    aws_organizations_account.moj-analytics-platform,
    aws_organizations_account.moj-cla,
    aws_organizations_account.moj-digital-services,
    aws_organizations_account.moj-lpa-development,
    aws_organizations_account.moj-lpa-preproduction,
    aws_organizations_account.moj-official-development,
    aws_organizations_account.moj-official-pre-production,
    aws_organizations_account.moj-official-production,
    aws_organizations_account.moj-official-public-key-infrastructure,
    aws_organizations_account.moj-official-public-key-infrastructure-dev,
    aws_organizations_account.moj-official-shared-services,
    aws_organizations_account.moj-opg-digicop-development,
    aws_organizations_account.moj-opg-digicop-preproduction,
    aws_organizations_account.moj-opg-digicop-production,
    aws_organizations_account.moj-opg-identity,
    aws_organizations_account.moj-opg-lpa-production,
    aws_organizations_account.moj-opg-lpa-refunds-development,
    aws_organizations_account.moj-opg-lpa-refunds-preproduction,
    aws_organizations_account.moj-opg-lpa-refunds-production,
    aws_organizations_account.moj-opg-management,
    aws_organizations_account.moj-opg-sandbox,
    aws_organizations_account.moj-opg-shared-development,
    aws_organizations_account.moj-opg-shared-production,
    aws_organizations_account.moj-opg-sirius-development,
    aws_organizations_account.moj-opg-sirius-preproduction,
    aws_organizations_account.moj-opg-sirius-production,
    aws_organizations_account.moj-security,
    aws_organizations_account.opg-backups,
    aws_organizations_account.opg-digi-deps-dev,
    aws_organizations_account.opg-digi-deps-preprod,
    aws_organizations_account.opg-digi-deps-prod,
    aws_organizations_account.opg-lpa-production,
    aws_organizations_account.opg-refund-develop,
    aws_organizations_account.opg-refund-production,
    aws_organizations_account.opg-shared,
    aws_organizations_account.opg-sirius-backup,
    aws_organizations_account.opg-sirius-dev,
    aws_organizations_account.opg-sirius-production,
    aws_organizations_account.opg-use-my-lpa-development,
    aws_organizations_account.opg-use-my-lpa-preproduction,
    aws_organizations_account.opg-use-my-lpa-production,
    aws_organizations_account.organisation-logging,
    aws_organizations_account.patterns,
    aws_organizations_account.security-engineering,
    aws_organizations_account.security-logging-platform,
    aws_organizations_account.security-operations-development,
    aws_organizations_account.security-operations-pre-production,
    aws_organizations_account.security-operations-production,
    aws_organizations_account.tacticalproducts,
    aws_organizations_account.workplace-tech-proof-of-concept-development,
    aws_organizations_account.wptpoc
  ], local.modernisation-platform-managed-account-ids)
}

##############################
# GuardDuty within eu-west-2 #
##############################

# Enable GuardDuty for the default provider region, which is required to delegate a GuardDuty administrator
resource "aws_guardduty_detector" "default-region" {
  # Set enable to false if you want to suspend GuardDuty.
  # This allows you to keep historical findings rather than removing the resource
  # block, which will destroy all historical findings
  enable = true

  tags = local.root_account
}

# Delegate administratorship of GuardDuty to the organisation-security account for the default provider region
resource "aws_guardduty_organization_admin_account" "default-region-administrator" {
  depends_on       = [aws_organizations_organization.default]
  admin_account_id = aws_organizations_account.organisation-security.id
}

####################################
# GuardDuty detector for eu-west-2 #
####################################

# The detector is automatically created by AWS, so we need to import it before Terraform will manage it
resource "aws_guardduty_detector" "organisation-security-eu-west-2" {
  provider = aws.organisation-security-eu-west-2

  # Set enable to false if you want to suspend GuardDuty.
  # This allows you to keep historical findings rather than removing the resource
  # block, which will destroy all historical findings
  enable = true

  # This will send GuardDuty notifications every 15 minutes, rather than every
  # 6 hours (default)
  finding_publishing_frequency = "FIFTEEN_MINUTES"

  tags = merge(
    local.tags-organisation-management, {
      component = "Security"
    }
  )
}

##################################################
# GuardDuty publishing destination for eu-west-2 #
##################################################

resource "aws_guardduty_publishing_destination" "eu-west-2" {
  provider = aws.organisation-security-eu-west-2

  detector_id     = aws_guardduty_detector.organisation-security-eu-west-2.id
  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  depends_on = [
    aws_s3_bucket_policy.guardduty-bucket-policy
  ]
}

################################
# Member accounts in eu-west-2 #
################################

resource "aws_guardduty_member" "eu-west-2" {
  for_each = {
    for account in local.enrolled_into_guardduty :
    account.name => account.id
  }
  provider = aws.organisation-security-eu-west-2

  # We want to add these accounts as members within the Organisation Security account
  account_id  = each.value
  detector_id = aws_guardduty_detector.organisation-security-eu-west-2.id
  email       = "fake@email.com"
  invite      = true

  # With AWS Organizations, AWS doesn't rely on the email address provided to invite a member account,
  # as privilege is inferred by the fact that the account is already within Organizations.
  # However, once a relationship is established, the GuardDuty API returns an email address, so Terraform returns a drift.
  # Therefore, we can ignore_changes to an email address. You still need to provide one, though, so we use fake@email.com.
  lifecycle {
    ignore_changes = [
      email
    ]
  }
}
