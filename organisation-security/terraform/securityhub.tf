##############################
# Security Hub in EU regions #
##############################
module "securityhub_eu_west_2" {
  source = "../../modules/securityhub"
  providers = {
    aws = aws.eu-west-2
  }
  modernisation_platform_account_id = var.modernisation_platform_account_id

  aggregation_region = true

  is_delegated_administrator = true
}

module "securityhub_eu_west_1" {
  source = "../../modules/securityhub"
  providers = {
    aws = aws.eu-west-1
  }
  modernisation_platform_account_id = var.modernisation_platform_account_id

  is_delegated_administrator = true
}

module "securityhub_eu_west_3" {
  source = "../../modules/securityhub"
  providers = {
    aws = aws.eu-west-3
  }
  modernisation_platform_account_id = var.modernisation_platform_account_id

  is_delegated_administrator = true
}

module "securityhub_eu_central_1" {
  source = "../../modules/securityhub"
  providers = {
    aws = aws.eu-central-1
  }
  modernisation_platform_account_id = var.modernisation_platform_account_id

  is_delegated_administrator = true
}

##############################
# Security Hub in US regions #
##############################
module "securityhub_us_east_1" {
  providers = {
    aws = aws.us-east-1
  }

  source = "../../modules/securityhub"

  is_delegated_administrator = true

  modernisation_platform_account_id = var.modernisation_platform_account_id
}
