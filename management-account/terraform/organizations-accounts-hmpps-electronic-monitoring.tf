locals {
  tags_electronic_monitoring = local.tags_business_units.hmpps
}

# Electronic Monitoring Identity & Access Management
resource "aws_organizations_account" "electronic_monitoring_identity_and_access_management" {
  name                       = "Electronic Monitoring Identity & Access Management"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-idam")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_electronic_monitoring.id
  close_on_deletion          = true

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

# Electronic Monitoring Shared Logging
resource "aws_organizations_account" "electronic_monitoring_shared_logging" {
  name                       = "Electronic Monitoring Shared Logging"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-shared-logging")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_electronic_monitoring.id
  close_on_deletion          = true

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
