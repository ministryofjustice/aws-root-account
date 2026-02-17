resource "aws_organizations_account" "organisation_logging" {
  name                       = "organisation-logging"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "organisation-logging")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.organisation_management.id
  close_on_deletion          = true

  tags = merge(local.tags_platforms, {
    is-production          = true
    application            = "organisation-logging"
    environment-name       = "organisation-logging"
    owner                  = "Hosting leads: hosting-leads@digital.justice.gov.uk"
    infrastructure-support = "Hosting leads: hosting-leads@digital.justice.gov.uk"
    source-code            = local.github_repository
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
  name                       = "organisation-security"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "organisation-security")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.organisation_management.id
  close_on_deletion          = true

  tags = merge(local.tags_platforms, {
    is-production          = true
    application            = "organisation-security"
    environment-name       = "organisation-security"
    owner                  = "Hosting leads: hosting-leads@digital.justice.gov.uk"
    infrastructure-support = "Hosting leads: hosting-leads@digital.justice.gov.uk"
    source-code            = local.github_repository
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
