# Electronic Monitoring Case Management
resource "aws_organizations_account" "electronic-monitoring-case-management-development" {
  name                       = "Electronic Monitoring Case Management dev"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-cm-dev")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps-electronic-monitoring-case-management.id
  tags                       = local.tags-hmpps-em

  lifecycle {
    # If any of these attributes are changed, it attempts to destroy and recreate the account,
    # so we should ignore the changes to prevent this from happening.
    ignore_changes = [
      name,
      email,
      iam_user_access_to_billing,
      role_name
    ]
  }
}

resource "aws_organizations_account" "electronic-monitoring-case-management-preprod" {
  name                       = "Electronic Monitoring Case Management preprod"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-cm-preprod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps-electronic-monitoring-case-management.id
  tags                       = local.tags-hmpps-em

  lifecycle {
    # If any of these attributes are changed, it attempts to destroy and recreate the account,
    # so we should ignore the changes to prevent this from happening.
    ignore_changes = [
      name,
      email,
      iam_user_access_to_billing,
      role_name
    ]
  }
}

resource "aws_organizations_account" "electronic-monitoring-case-management-production" {
  name                       = "Electronic Monitoring Case Management prod"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-cm-prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps-electronic-monitoring-case-management.id
  tags                       = local.tags-hmpps-em

  lifecycle {
    # If any of these attributes are changed, it attempts to destroy and recreate the account,
    # so we should ignore the changes to prevent this from happening.
    ignore_changes = [
      name,
      email,
      iam_user_access_to_billing,
      role_name
    ]
  }
}
