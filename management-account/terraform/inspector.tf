#############
# Inspector #
#############

# Delegate to organisation security account
resource "aws_inspector2_delegated_admin_account" "eu_west_2" {
  provider = aws.eu-west-2
  account_id = aws_organizations_account.organisation_security.id
}

resource "aws_inspector2_delegated_admin_account" "eu_west_1" {
  provider = aws.eu-west-1
  account_id = aws_organizations_account.organisation_security.id
}
