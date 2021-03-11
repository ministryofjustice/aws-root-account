resource "aws_organizations_organization" "default" {
  aws_service_access_principals = [
    "access-analyzer.amazonaws.com",
    "compute-optimizer.amazonaws.com",
    "guardduty.amazonaws.com",
    "health.amazonaws.com",
    "ram.amazonaws.com",
    "reporting.trustedadvisor.amazonaws.com",
    "securityhub.amazonaws.com",
    "sso.amazonaws.com",
    "storage-lens.s3.amazonaws.com",
    "tagpolicies.tag.amazonaws.com"
  ]
  enabled_policy_types = [
    "AISERVICES_OPT_OUT_POLICY",
    "SERVICE_CONTROL_POLICY",
    "TAG_POLICY"
  ]
  feature_set = "ALL"
}

# Note that whatever is attached here is inherited by all sub-accounts
# See: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_inheritance.html
resource "aws_organizations_policy_attachment" "default" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organization.default.roots[0].id
}

# Enrol all accounts within the AWS Organization to unenforced tag policies
# Note that when you attach a tag policy, it can take 48 hours to evaluate compliance
# See: https://docs.aws.amazon.com/organizations/latest/userguide/attach-tag-policy.html
resource "aws_organizations_policy_attachment" "mandatory-tags-policy" {
  policy_id = aws_organizations_policy.mandatory-tags.id
  target_id = aws_organizations_organization.default.roots[0].id
}

resource "aws_organizations_policy_attachment" "optional-tags-policy" {
  policy_id = aws_organizations_policy.optional-tags.id
  target_id = aws_organizations_organization.default.roots[0].id
}

# Enrol all accounts within the AWS Organization to opting out of AWS AI services using our
# data and content to train the AI services and models.
resource "aws_organizations_policy_attachment" "ai-services-opt-out" {
  policy_id = aws_organizations_policy.ai-services-opt-out-policy.id
  target_id = aws_organizations_organization.default.roots[0].id
}

# If you're going to create a new account using this Terraform,
# note that you'll have to import any aws_organizations_policy_attachment resources manually as
# Terraform will fail to create them (as AWS attaches them on your behalf).
# When it does fail, import it into Terraform, so we can explicitly track what policies accounts have.
