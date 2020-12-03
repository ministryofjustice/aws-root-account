resource "aws_organizations_organization" "default" {
  aws_service_access_principals = [
    "reporting.trustedadvisor.amazonaws.com",
    "sso.amazonaws.com"
  ]
  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY"
  ]
  feature_set = "ALL"
}

# Note that whatever is attached here is inherited by all sub-accounts
# See: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_inheritance.html
resource "aws_organizations_policy_attachment" "default" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organization.default.roots[0].id
}
