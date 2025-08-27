resource "aws_account_alternate_contact" "operations" {
  alternate_contact_type = "OPERATIONS"
  email_address          = "modernisation-platform@digital.justice.gov.uk"
  name                   = "Modernisation Platform"
  title                  = "Team"
  phone_number           = "+0000000000"
}

resource "aws_account_alternate_contact" "billing" {
  alternate_contact_type = "BILLING"
  email_address          = "modernisation-platform@digital.justice.gov.uk"
  name                   = "Modernisation Platform Team"
  title                  = "Team"
  phone_number           = "+0000000000"
}
