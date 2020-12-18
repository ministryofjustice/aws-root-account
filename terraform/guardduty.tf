# Enable GuardDuty for the calling region
resource "aws_guardduty_detector" "default-region" {
  enable = true
}

# Delegate administratorship of GuardDuty to the organisation-security account
resource "aws_guardduty_organization_admin_account" "default-region-administrator" {
  depends_on       = [aws_organizations_organization.default]
  admin_account_id = aws_organizations_account.organisation-security.id
}
