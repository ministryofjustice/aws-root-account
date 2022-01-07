######################
# Alternate Contacts #
######################

# AWS supports three types of alternate contacts, in addition to sending emails to the root account address:
#
# - Billing
# - Operations
# - Security
#
# This Terraform resource aligns the SECURITY alternate contact for all AWS accounts to be the same as
# what is defined in the MOJ Security Guidance (https://security-guidance.service.justice.gov.uk/baseline-aws-accounts/#baseline-for-amazon-web-services-accounts).

locals {
  alternate_contacts_accounts = {
    for account in aws_organizations_organization.default.accounts :
    account.name => account.id
  }
}

resource "aws_account_alternate_contact" "security" {
  for_each = local.alternate_contacts_accounts

  account_id             = each.value
  alternate_contact_type = "SECURITY"
  name                   = "Security team"
  title                  = "Mx"
  email_address          = "security@justice.gov.uk"
  phone_number           = "00000000000"

  lifecycle {
    ignore_changes = [
      phone_number
    ]
  }

  depends_on = [aws_organizations_organization.default]
}
