resource "aws_organizations_organization" "default" {
  aws_service_access_principals = [
    "access-analyzer.amazonaws.com",
    "compute-optimizer.amazonaws.com",
    "guardduty.amazonaws.com",
    "ram.amazonaws.com",
    "reporting.trustedadvisor.amazonaws.com",
    "sso.amazonaws.com",
    "storage-lens.s3.amazonaws.com",
    "tagpolicies.tag.amazonaws.com"
  ]
  enabled_policy_types = [
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

# If you're going to create a new account using this Terraform,
# note that you'll have to import any aws_organizations_policy_attachment resources manually as
# Terraform will fail to create them (as AWS attaches them on your behalf).
# When it does fail, import it into Terraform, so we can explicitly track what policies accounts have.
