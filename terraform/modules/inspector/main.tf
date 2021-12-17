#################
# AWS Inspector #
#################

# Get the delegated administrator account ID
data "aws_caller_identity" "delegated-administrator" {
  provider = aws.delegated-administrator
}

resource "aws_organizations_delegated_administrator" "default" {
  account_id        = data.aws_caller_identity.delegated-administrator.account_id
  service_principal = "inspector2.amazonaws.com"
}
