locals {
  tags_hmcts = local.tags_business_units.hmcts
}

# Contains UTIAC Tribunals docs in S3 - migrating November 2023
resource "aws_organizations_account" "ministry_of_justice_courtfinder_prod" {
  name                       = "Ministry of Justice Courtfinder Prod"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "courtfinder-prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmcts.id
  close_on_deletion          = true

  tags = local.tags_hmcts

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

