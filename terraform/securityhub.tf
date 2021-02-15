#################################
# Security Hub within eu-west-2 #
#################################

# Enable Security Hub for the default provider region, which is required to delegate a Security Hub administrator
module "securityhub-default-region" {
  source = "./modules/securityhub"
}

# Enable SecurityHub in the organisation-security account, which is required to become a delegated administrator
module "securityhub-organisation-security-eu-west-2" {
  providers = {
    aws = aws.organisation-security-eu-west-2
  }

  source = "./modules/securityhub"
}

# Delegate administratorship of Security Hub to organisation-security
resource "aws_securityhub_organization_admin_account" "default-region-administrator" {
  depends_on = [
    aws_organizations_organization.default,
    module.securityhub-organisation-security-eu-west-2
  ]
  admin_account_id = aws_organizations_account.organisation-security.id
}
