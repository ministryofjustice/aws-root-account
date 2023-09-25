# Create an organisation zone of trust to audit member accounts IAM policies.
# You can't see the organisation root of trust within member accounts in the AWS Organization, so each
# account should enable an account zone of trust.

# As of 29/12/2020, Terraform doesn't support delegated administrators for IAM Access Analyzer.
# We have manually set the delegated administrator to be the organisation-security account via
# the console (https://eu-west-2.console.aws.amazon.com/access-analyzer/home?region=eu-west-2#/settings).

# eu-west-2 (organisation zone of trust in the eu-west-2 region of the organisation-security account)

locals {
  access_analyzer_tags = {
    "application"            = "Organisation Management"
    "business-unit"          = "Platforms"
    "component"              = "Security"
    "infrastructure-support" = "Hosting Leads: hosting-leads@digital.justice.gov.uk"
    "is-production"          = "true"
    "owner"                  = "Hosting Leads: hosting-leads@digital.justice.gov.uk"
    "source-code"            = "github.com/ministryofjustice/aws-root-account"
  }
}

resource "aws_accessanalyzer_analyzer" "organisation_eu_west_2" {
  provider = aws.eu-west-2

  analyzer_name = "organisation-zone-of-trust"
  type          = "ORGANIZATION"

  tags = local.access_analyzer_tags
}

# eu-west-1 (organisation zone of trust in the eu-west-1 region of the organisation-security account)
resource "aws_accessanalyzer_analyzer" "organisation_eu_west_1" {
  provider = aws.eu-west-1

  analyzer_name = "organisation-zone-of-trust"
  type          = "ORGANIZATION"

  tags = local.access_analyzer_tags

}
