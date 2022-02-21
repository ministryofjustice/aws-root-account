# This resource (`aws_organizations_organization`) is now managed in management-account/terraform/organizations.tf
# It has been left here whilst the other aws_organizations_* resources are moved (as there is a dependency on it)
resource "aws_organizations_organization" "default" {
  aws_service_access_principals = [
    "access-analyzer.amazonaws.com",
    "account.amazonaws.com",
    "compute-optimizer.amazonaws.com",
    "config.amazonaws.com",
    "detective.amazonaws.com",
    "fms.amazonaws.com",
    "guardduty.amazonaws.com",
    "health.amazonaws.com",
    "inspector2.amazonaws.com",
    "ipam.amazonaws.com",
    "license-management.marketplace.amazonaws.com",
    "license-manager.amazonaws.com",
    "license-manager.member-account.amazonaws.com",
    "ram.amazonaws.com",
    "reporting.trustedadvisor.amazonaws.com",
    "securityhub.amazonaws.com",
    "ssm.amazonaws.com",
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

  lifecycle {
    ignore_changes = [
      aws_service_access_principals,
      enabled_policy_types,
      feature_set
    ]
  }
}

# Note that whatever is attached here is inherited by all sub-accounts
# See: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_inheritance.html
resource "aws_organizations_policy_attachment" "default" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organization.default.roots[0].id
}
