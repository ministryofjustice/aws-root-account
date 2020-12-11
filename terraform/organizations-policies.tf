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
    source-code   = join("", [local.github_repository, "organizations-policies.tf"])
  }
}
