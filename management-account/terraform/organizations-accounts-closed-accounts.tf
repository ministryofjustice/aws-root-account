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

# MoJ Security, a legacy account for log collection that is no longer used
resource "aws_organizations_account" "moj_security" {
  name                       = "MoJ Security"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "moj+security")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.closed_accounts.id

  tags = local.tags_security

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

# SecOps Production, a legacy account used to host the Rapid7 console
resource "aws_organizations_account" "security_operations_production" {
  name                       = "Security Operations Production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "secops-prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.closed_accounts.id

  tags = local.tags_security

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}
