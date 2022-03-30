####################
# Firewall Manager #
####################
resource "aws_fms_admin_account" "default" {
  provider   = aws.us-east-1
  account_id = aws_organizations_account.organisation_security.id
}
