resource "aws_organizations_account" "organisation_logging" {
  name                       = "Organisation Logging"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "organisation-logging")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.organisation_management.id

  tags = merge(local.tags_platforms, {
    is-production = true
  })

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "organisation_security" {
  name                       = "Organisation Security"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "organisation-security")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.organisation_management.id

  tags = merge(local.tags_platforms, {
    is-production = true
  })

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}
