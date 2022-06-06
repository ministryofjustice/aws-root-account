resource "aws_organizations_account" "hmpps_dev" {
  name                       = "HMPPS Dev"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-dev")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.platforms_and_architecture_digital_studio_operations.id

  tags = merge(local.tags_platforms, {
    application            = "Digtial Studio Operations development"
    environment-name       = "dso-hmpps-dev"
    infrastructure-support = "Digital Studio Operations: digital-studio-operations-team@digital.justice.gov.uk"
    owner                  = "Digital Studio Operations: digital-studio-operations-team@digital.justice.gov.uk"
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

resource "aws_organizations_account" "hmpps_management" {
  name                       = "HMPPS Management"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-mgmt")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.platforms_and_architecture_digital_studio_operations.id

  tags = merge(local.tags_platforms, {
    application            = "Digital Studio Operations management"
    environment-name       = "dso-hmpps-management"
    infrastructure-support = "Digital Studio Operations: digital-studio-operations-team@digital.justice.gov.uk"
    owner                  = "Digital Studio Operations: digital-studio-operations-team@digital.justice.gov.uk"
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

resource "aws_organizations_account" "hmpps_prod" {
  name                       = "HMPPS PROD"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.platforms_and_architecture_digital_studio_operations.id

  tags = merge(local.tags_platforms, {
    application            = "Digital Studio Operations production"
    environment-name       = "dso-hmpps-prod"
    infrastructure-support = "Digital Studio Operations: digital-studio-operations-team@digital.justice.gov.uk"
    owner                  = "Digital Studio Operations: digital-studio-operations-team@digital.justice.gov.uk"
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
