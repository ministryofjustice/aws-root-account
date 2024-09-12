######################
# Alternate Contacts #
######################

# See: https://docs.aws.amazon.com/accounts/latest/reference/API_AlternateContact.html

# This Terraform resource aligns the SECURITY alternate contact for all AWS accounts to match MOJ's Security Guidance
# See: https://security-guidance.service.justice.gov.uk/baseline-aws-accounts/#baseline-for-amazon-web-services-accounts

# TODO: Delete after testing has finished

resource "aws_account_alternate_contact" "security" {
  for_each = local.accounts.active_only

  # The AWS management account needs to omit the account ID to manage itself
  account_id = aws_organizations_organization.default.master_account_id == each.value ? null : each.value

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
