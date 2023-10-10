##########
# Config #
##########

# Configure IAM role for Config usage within Organizations
data "aws_iam_policy_document" "config_organization" {
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

resource "aws_iam_role" "config_organization" {
  name               = "AWSConfigOrganizationAggregator"
  assume_role_policy = data.aws_iam_policy_document.config_organization.json
}

resource "aws_iam_role_policy_attachment" "config_organization" {
  role       = aws_iam_role.config_organization.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRoleForOrganizations"
}

resource "aws_config_configuration_aggregator" "config_organization" {
  name = "organization-aggregator"

  organization_aggregation_source {
    all_regions = true
    role_arn    = aws_iam_role.config_organization.arn
  }

  depends_on = [aws_iam_role_policy_attachment.config_organization]
}
