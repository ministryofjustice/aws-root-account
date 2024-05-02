#############
# IPAM #
#############

# Delegate to organisation security account

resource "aws_vpc_ipam_organization_admin_account" "eu_west_2" {
  provider                   = aws.eu-west-2
  delegated_admin_account_id = aws_organizations_account.organisation_security.id
}

resource "aws_vpc_ipam_organization_admin_account" "eu_west_1" {
  provider                   = aws.eu-west-1
  delegated_admin_account_id = aws_organizations_account.organisation_security.id
}

resource "aws_vpc_ipam_organization_admin_account" "eu_central_1" {
  provider                   = aws.eu-central-1
  delegated_admin_account_id = aws_organizations_account.organisation_security.id
}
