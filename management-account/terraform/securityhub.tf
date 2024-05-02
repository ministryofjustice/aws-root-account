##############################
# Security Hub in EU regions #
##############################
module "securityhub_eu_west_2" {
  source = "../../modules/securityhub"
  providers = {
    aws = aws.eu-west-2
  }

  admin_account = aws_organizations_account.organisation_security.id
}

module "securityhub_eu_west_1" {
  source = "../../modules/securityhub"
  providers = {
    aws = aws.eu-west-1
  }

  admin_account = aws_organizations_account.organisation_security.id
}

module "securityhub_eu_central_1" {
  source = "../../modules/securityhub"
  providers = {
    aws = aws.eu-central-1
  }

  admin_account = aws_organizations_account.organisation_security.id
}

##############################
# Security Hub in US regions #
##############################
module "securityhub_us_east_1" {
  providers = {
    aws = aws.us-east-1
  }

  source = "../../modules/securityhub"

  admin_account = aws_organizations_account.organisation_security.id
}
