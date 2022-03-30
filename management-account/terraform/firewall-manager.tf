####################
# Firewall Manager #
####################
resource "aws_fms_admin_account" "default" {
  # Firewall Manager is a global service so needs to use the us-east-1 provider
  provider   = aws.us-east-1
  account_id = aws_organizations_account.organisation_security.id
}
