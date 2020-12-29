# Enable IAM Access Analyzer for the root account

# eu-west-2
resource "aws_accessanalyzer_analyzer" "account-default-region" {
  analyzer_name = "account-zone-of-trust"
}

# eu-west-1
resource "aws_accessanalyzer_analyzer" "account-eu-west-1" {
  provider = aws.aws-root-account-eu-west-1

  analyzer_name = "account-zone-of-trust"
}

# Create an organisation zone of trust to audit member accounts IAM policies.
# You can't see the organisation root of trust within member accounts in the AWS Organization, so each
# account should enable an account zone of trust.

# As of 29/12/2020, Terraform doesn't support delegated administrators for IAM Access Analyzer.
# We have manually set the delegated administrator to be the organisation-security account via
# the console (https://eu-west-2.console.aws.amazon.com/access-analyzer/home?region=eu-west-2#/settings).

# eu-west-2 (organisation zone of trust in the eu-west-2 region of the organisation-security account)
resource "aws_accessanalyzer_analyzer" "organisation-eu-west-2" {
  provider = aws.organisation-security-eu-west-2

  depends_on = [aws_organizations_organization.default]

  analyzer_name = "organisation-zone-of-trust"
  type          = "ORGANIZATION"
}

# eu-west-1 (organisation zone of trust in the eu-west-1 region of the organisation-security account)
resource "aws_accessanalyzer_analyzer" "organisation-eu-west-1" {
  provider = aws.organisation-security-eu-west-1

  depends_on = [aws_organizations_organization.default]

  analyzer_name = "organisation-zone-of-trust"
  type          = "ORGANIZATION"
}
