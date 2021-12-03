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
  not_enrolled_into_securityhub = [
    # OPG
    aws_organizations_account.moj-lpa-development.id,
    aws_organizations_account.moj-opg-digicop-development.id,
    aws_organizations_account.moj-opg-digicop-preproduction.id,
    aws_organizations_account.moj-opg-digicop-production.id,
    aws_organizations_account.moj-opg-identity.id,
    aws_organizations_account.moj-opg-lpa-refunds-development.id,
    aws_organizations_account.moj-opg-management.id,
    aws_organizations_account.moj-opg-sandbox.id,
    aws_organizations_account.opg-digi-deps-dev.id,
    aws_organizations_account.opg-lpa-production.id,
    aws_organizations_account.opg-modernising-lpa-development.id,
    aws_organizations_account.opg-modernising-lpa-preproduction.id,
    aws_organizations_account.opg-modernising-lpa-production.id,
    aws_organizations_account.opg-refund-production.id,
    aws_organizations_account.opg-shared.id,
    aws_organizations_account.opg-sirius-dev.id,
    # Youth Justice Board
    aws_organizations_account.youth-justice-framework-dev.id,
    aws_organizations_account.youth-justice-framework-eng-tools.id,
    aws_organizations_account.youth-justice-framework-juniper.id,
    aws_organizations_account.youth-justice-framework-management.id,
    aws_organizations_account.youth-justice-framework-monitoring.id,
    aws_organizations_account.youth-justice-framework-pre-prod.id,
    aws_organizations_account.youth-justice-framework-prod.id
  ]
  enrolled_into_securityhub = {
    for account in aws_organizations_organization.default.accounts :
    account.name => account.id
    # Don't enrol the organisation-security account (as it'll already be enabled as the delegated administrator)
    # Don't enrol suspended or removed (i.e. deleted) accounts
    if account.status == "ACTIVE" && account.name != "organisation-security" && !contains(local.not_enrolled_into_securityhub, account.id)
  }
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

  aggregation_region = true

  enrolled_into_securityhub = local.enrolled_into_securityhub

  depends_on = [aws_organizations_organization.default]
}

module "securityhub-eu-west-1" {
  source = "./modules/securityhub"

  providers = {
    aws.root-account            = aws.aws-root-account-eu-west-1
    aws.delegated-administrator = aws.organisation-security-eu-west-1
  }

  enrolled_into_securityhub = local.enrolled_into_securityhub

  depends_on = [aws_organizations_organization.default]
}
