# Note that every AWS account in an AWS organisation must have at least one SCP set.
# By default this is the FullAWSAccess policy, that can't be edited, so is not
# included in this Terraform.
# See: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples.html

# Before changing policies, please read how Organizations policy inheritance works.
# See: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_inheritance.html

# DenyCloudTrailDeleteStopUpdatePolicy
# Organization policies aren't actually IAM policies, but we can use the
# Terraform aws_iam_policy_document data block to create the correct JSON,
# with the correct formatting.
data "aws_iam_policy_document" "deny-cloudtrail-delete-stop-update-policy" {
  version = "2012-10-17"
  statement {
    effect = "Deny"
    actions = [
      "cloudtrail:DeleteTrail",
      "cloudtrail:StopLogging",
      "cloudtrail:UpdateTrail"
    ]
    resources = ["*"]
  }
}

resource "aws_organizations_policy" "deny-cloudtrail-delete-stop-update-policy" {
  name        = "DenyCloudTrailDeleteStopUpdatePolicy"
  description = "Denies changes to CloudTrail"
  type        = "SERVICE_CONTROL_POLICY"
  content     = data.aws_iam_policy_document.deny-cloudtrail-delete-stop-update-policy.json

  # This policy is currently used by LAA.
  tags = {
    business-unit = "LAA"
    component     = "SERVICE_CONTROL_POLICY"
    source-code   = join("", [local.github_repository, "/organizations-service-control-policies.tf"])
  }
}

# Denies operations outside selected EU regions for regional services and us-east-1 for global services
# and denies the ability to enable and deactivate regions
#
# This policy is a more generalised version of the AWS example:
# https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples.html#examples_general
#
# By allowing general access (all actions, all resources) to us-east-1, teams can use global services
# as they become available, rather than explicitly having to list them here (as with the example above).
data "aws_iam_policy_document" "deny-non-eu-non-us-east-1-operations" {
  version = "2012-10-17"

  # Deny operations outside of non-default EU regions
  statement {
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]

    condition {
      test     = "StringNotEquals"
      variable = "aws:RequestedRegion"
      values = [
        "eu-central-1", # Europe (Frankfurt)
        "eu-west-1",    # Europe (Ireland)
        "eu-west-2",    # Europe (London)
        "us-east-1",    # US East (N. Virginia) (for global services)
      ]
    }
  }

  # Deny enablement and disactivation of AWS opt-in regions (as of 04/01/2021)
  # including: Africa (Cape Town), Asia Pacific (Hong Kong), Europe (Milan), Middle East (Bahrain)
  statement {
    effect = "Deny"
    actions = [
      "account:DisableRegion",
      "account:EnableRegion"
    ]
    resources = ["*"]
  }
}

resource "aws_organizations_policy" "deny-non-eu-non-us-east-1-operations" {
  name        = "Deny non-EU and non-\"us-east-1\" operations"
  description = "Denies any API calls to non-default EU and non-\"us-east-1\" regions, and denies the ability to enable and deactivate opt-in regions. us-east-1 is included here as it hosts global services."
  type        = "SERVICE_CONTROL_POLICY"
  content     = data.aws_iam_policy_document.deny-non-eu-non-us-east-1-operations.json

  tags = {
    business-unit = "Platforms"
    component     = "SERVICE_CONTROL_POLICY"
    source-code   = join("", [local.github_repository, "/organizations-service-control-policies.tf"])
  }
}

resource "aws_organizations_policy_attachment" "modernisation-platform-regions-scp-policy" {
  policy_id = aws_organizations_policy.deny-non-eu-non-us-east-1-operations.id
  target_id = aws_organizations_account.modernisation-platform.id
}
