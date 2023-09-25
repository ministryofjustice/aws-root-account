# Enable IAM Access Analyzer for the root account
locals {
  access_analyzer_tags = {
    "application"   = "AWS root account"
    "business-unit" = "Platforms"
    "is-production" = "true"
    "owner"         = "Hosting Leads: hosting-leads@digital.justice.gov.uk"
  }
}

# eu-west-2
resource "aws_accessanalyzer_analyzer" "account_eu_west_2" {
  provider      = aws.eu-west-2
  analyzer_name = "account-zone-of-trust"
  type          = "ACCOUNT"
  tags          = local.access_analyzer_tags
}

# eu-west-1
resource "aws_accessanalyzer_analyzer" "account_eu_west_1" {
  provider      = aws.eu-west-1
  analyzer_name = "account-zone-of-trust"
  type          = "ACCOUNT"
  tags          = local.access_analyzer_tags
}

# As of 29/12/2020, Terraform doesn't support delegated administrators for IAM Access Analyzer.
# We have manually set the delegated administrator to be the organisation-security account via
# the console (https://eu-west-2.console.aws.amazon.com/access-analyzer/home?region=eu-west-2#/settings).
