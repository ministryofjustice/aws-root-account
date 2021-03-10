#################################
# Security Hub within eu-west-2 #
#################################

locals {
  enrolled_into_securityhub = concat([
    { id = local.caller_identity.account_id, name = "MoJ root account" },
    aws_organizations_account.legal-aid-agency,
    aws_organizations_account.modernisation-platform,
  ], local.modernisation-platform-managed-account-ids)
}

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
