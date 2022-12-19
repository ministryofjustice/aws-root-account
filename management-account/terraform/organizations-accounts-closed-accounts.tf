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
