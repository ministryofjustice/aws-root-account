resource "aws_organizations_organization" "default" {
  aws_service_access_principals = [
    "access-analyzer.amazonaws.com",
    "account.amazonaws.com",
    "backup.amazonaws.com",
    "billing-cost-management.amazonaws.com",
    "compute-optimizer.amazonaws.com",
    "config.amazonaws.com",
    "cost-optimization-hub.bcm.amazonaws.com",
    "detective.amazonaws.com",
    "fms.amazonaws.com",
    "guardduty.amazonaws.com",
    "health.amazonaws.com",
    "inspector2.amazonaws.com",
    "ipam.amazonaws.com",
    "license-management.marketplace.amazonaws.com",
    "license-manager-linux-subscriptions.amazonaws.com",
    "license-manager.amazonaws.com",
    "license-manager.member-account.amazonaws.com",
    "macie.amazonaws.com",
    "malware-protection.guardduty.amazonaws.com",
    "member.org.stacksets.cloudformation.amazonaws.com",
    "ram.amazonaws.com",
    "reporting.trustedadvisor.amazonaws.com",
    "securityhub.amazonaws.com",
    "sso.amazonaws.com",
    "storage-lens.s3.amazonaws.com",
    "tagpolicies.tag.amazonaws.com",
  ]

  enabled_policy_types = [
    "AISERVICES_OPT_OUT_POLICY",
    "SERVICE_CONTROL_POLICY",
    "TAG_POLICY",
  ]

  feature_set = "ALL"
}

# Delegate Cloudformation Stacksets to organisation-security
resource "aws_organizations_delegated_administrator" "stacksets_organisation_security" {
  account_id        = aws_organizations_account.organisation_security.id
  service_principal = "member.org.stacksets.cloudformation.amazonaws.com"
}

# Enable RAM sharing with the organization without requiring acceptors
resource "aws_ram_sharing_with_organization" "default" {}
