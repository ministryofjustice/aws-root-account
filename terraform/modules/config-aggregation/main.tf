##########
# Config #
##########

# Get the organization management account ID
data "aws_caller_identity" "default" {
  provider = aws.root-account
}

# Get the delegated administrator account ID
data "aws_caller_identity" "delegated-administrator" {
  provider = aws.delegated-administrator
}

# Set appropriate delegated administrator for AWS Config MRAA
resource "aws_organizations_delegated_administrator" "delegated-administrator" {
  provider          = aws.root-account
  account_id        = data.aws_caller_identity.delegated-administrator.account_id
  service_principal = "config.amazonaws.com"
}

# Configure IAM role for Config usage within Organizations
data "aws_iam_policy_document" "config-organization" {
  version = "2012-10-17"

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "config-organization" {
  provider           = aws.delegated-administrator
  name               = "AWSConfigOrganizationAggregator"
  assume_role_policy = data.aws_iam_policy_document.config-organization.json
}

resource "aws_iam_role_policy_attachment" "config-organization" {
  provider   = aws.delegated-administrator
  role       = aws_iam_role.config-organization.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRoleForOrganizations"
}

resource "aws_config_configuration_aggregator" "config-organization" {
  provider = aws.delegated-administrator
  name     = "organization-aggregator"

  organization_aggregation_source {
    all_regions = true
    role_arn    = aws_iam_role.config-organization.arn
  }

  depends_on = [aws_iam_role_policy_attachment.config-organization]
}
