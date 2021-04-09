# Accounts to attach from the AWS Organization
# This is currently done by adding accounts on a one-by-one basis as
# we need to onboard people singularly rather than all at once.
# In the future we can replace all of this with a for_each on a
# data.aws_organizations_organization.example.accounts[*].id data resource,
# and auto_enable will be turned on so new accounts won't need to be added here.
# Any account added here in the meanwhile will have Security Hub enabled in:
# - eu-west-2
# - eu-west-1

# Security Hub will alert you if AWS Config (a prerequesite for Security Hub) isn't enabled
# in the region you're adding an member account to.
locals {
  enrolled_into_securityhub = concat([
    { id = local.caller_identity.account_id, name = "MoJ root account" },
    aws_organizations_account.alfresco-non-prod,
    aws_organizations_account.analytical-platform-data-engineering,
    aws_organizations_account.analytical-platform-development,
    aws_organizations_account.analytical-platform-landing,
    aws_organizations_account.analytical-platform-production,
    aws_organizations_account.analytics-platform-development,
    aws_organizations_account.cloud-platform,
    aws_organizations_account.cloud-platform-ephemeral-test,
    aws_organizations_account.cloud-platform-transit-gateways,
    aws_organizations_account.delius-core-non-prod,
    aws_organizations_account.delius-new-tech-non-prod,
    aws_organizations_account.hmpps-co-financing-organisation,
    aws_organizations_account.hmpps-community-rehabilitation-jira-non-production,
    aws_organizations_account.hmpps-community-rehabilitation-jira-production,
    aws_organizations_account.hmpps-community-rehabilitation-jitbit-non-production,
    aws_organizations_account.hmpps-community-rehabilitation-jitbit-production,
    aws_organizations_account.hmpps-community-rehabilitation-unpaid-work-non-production,
    aws_organizations_account.hmpps-community-rehabilitation-unpaid-work-production,
    aws_organizations_account.hmpps-delius-mis-non-prod,
    aws_organizations_account.hmpps-delius-performance,
    aws_organizations_account.hmpps-delius-po-test-1,
    aws_organizations_account.hmpps-delius-po-test-2,
    aws_organizations_account.hmpps-delius-pre-production,
    aws_organizations_account.hmpps-delius-stage,
    aws_organizations_account.hmpps-delius-test,
    aws_organizations_account.hmpps-delius-training,
    aws_organizations_account.hmpps-delius-training-test,
    aws_organizations_account.hmpps-dev,
    aws_organizations_account.hmpps-engineering-production,
    aws_organizations_account.hmpps-management,
    aws_organizations_account.hmpps-probation-production,
    aws_organizations_account.hmpps-prod,
    aws_organizations_account.hmpps-security-audit,
    aws_organizations_account.hmpps-victim-case-management-system-integration,
    aws_organizations_account.hmpps-victim-case-management-system-performance,
    aws_organizations_account.hmpps-victim-case-management-system-pre-production,
    aws_organizations_account.hmpps-victim-case-management-system-production,
    aws_organizations_account.hmpps-victim-case-management-system-stage,
    aws_organizations_account.hmpps-victim-case-management-system-test,
    aws_organizations_account.laa-cloudtrail,
    aws_organizations_account.laa-development,
    aws_organizations_account.laa-production,
    aws_organizations_account.laa-shared-services,
    aws_organizations_account.laa-staging,
    aws_organizations_account.laa-test,
    aws_organizations_account.laa-uat,
    aws_organizations_account.legal-aid-agency,
    aws_organizations_account.modernisation-platform,
    aws_organizations_account.moj-analytics-platform,
    aws_organizations_account.moj-digital-services,
    aws_organizations_account.moj-lpa-preproduction,
    aws_organizations_account.moj-official-development,
    aws_organizations_account.moj-official-pre-production,
    aws_organizations_account.moj-official-production,
    aws_organizations_account.moj-official-public-key-infrastructure,
    aws_organizations_account.moj-official-public-key-infrastructure-dev,
    aws_organizations_account.moj-official-shared-services,
    aws_organizations_account.moj-opg-lpa-production,
    aws_organizations_account.moj-opg-lpa-refunds-preproduction,
    aws_organizations_account.moj-opg-lpa-refunds-production,
    aws_organizations_account.moj-opg-shared-development,
    aws_organizations_account.moj-opg-shared-production,
    aws_organizations_account.moj-opg-sirius-preproduction,
    aws_organizations_account.moj-security,
    aws_organizations_account.network-architecture,
    aws_organizations_account.opg-backups,
    aws_organizations_account.opg-digi-deps-preprod,
    aws_organizations_account.opg-digi-deps-prod,
    aws_organizations_account.opg-sirius-backup,
    aws_organizations_account.opg-sirius-production,
    aws_organizations_account.probation,
    aws_organizations_account.probation-management-non-prod,
    aws_organizations_account.security-engineering,
    aws_organizations_account.security-logging-platform,
    aws_organizations_account.security-operations-development,
    aws_organizations_account.security-operations-pre-production,
    aws_organizations_account.security-operations-production,
    aws_organizations_account.strategic-partner-gateway-non-production,
    aws_organizations_account.vcms-non-prod,
    aws_organizations_account.workplace-tech-proof-of-concept-development,
    aws_organizations_account.wptpoc,
  ], local.modernisation-platform-managed-account-ids)
}

##############################
# Security Hub in EU regions #
##############################
module "securityhub-eu-west-2" {
  source = "./modules/securityhub"

  providers = {
    aws.root-account            = aws.aws-root-account-eu-west-2
    aws.delegated-administrator = aws.organisation-security-eu-west-2
  }

  enrolled_into_securityhub = {
    for account in local.enrolled_into_securityhub :
    account.name => account.id
  }

  depends_on = [aws_organizations_organization.default]
}

module "securityhub-eu-west-1" {
  source = "./modules/securityhub"

  providers = {
    aws.root-account            = aws.aws-root-account-eu-west-1
    aws.delegated-administrator = aws.organisation-security-eu-west-1
  }

  enrolled_into_securityhub = {
    for account in local.enrolled_into_securityhub :
    account.name => account.id
  }

  depends_on = [aws_organizations_organization.default]
}
