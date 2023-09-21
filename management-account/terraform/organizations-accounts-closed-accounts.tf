# Electronic Monitoring (ProMon)
resource "aws_organizations_account" "electronic_monitoring" {
  name                       = "Electronic Monitoring"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-monitoring-mapping-test") # Repurposed account
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.closed_accounts.id

  tags = merge(local.tags_electronic_monitoring, {

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

# Legal Aid Agency (sandbox)
resource "aws_organizations_account" "legal_aid_agency" {
  name                       = "Legal Aid Agency"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "legalaid")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.closed_accounts.id

  tags = local.tags_laa

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "moj_info_services_dev" {
  name                       = "MoJ Info Services Dev"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "courtfinder")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.closed_accounts.id

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