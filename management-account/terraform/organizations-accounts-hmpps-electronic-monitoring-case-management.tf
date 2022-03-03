locals {
  tags_electronic_monitoring_case_management = local.tags_business_units.hmpps
}

resource "aws_organizations_account" "electronic_monitoring_case_management_dev" {
  name                       = "Electronic Monitoring Case Management dev"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-cm-dev")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_electronic_monitoring_case_management.id

  tags = merge(local.tags_electronic_monitoring_case_management, {

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

resource "aws_organizations_account" "electronic_monitoring_case_management_preprod" {
  name                       = "Electronic Monitoring Case Management preprod"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-cm-preprod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_electronic_monitoring_case_management.id

  tags = merge(local.tags_electronic_monitoring_case_management, {

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

resource "aws_organizations_account" "electronic_monitoring_case_management_prod" {
  name                       = "Electronic Monitoring Case Management prod"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-cm-prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_electronic_monitoring_case_management.id

  tags = merge(local.tags_electronic_monitoring_case_management, {
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

# Electronic Monitoring Case Management Networking prod
resource "aws_organizations_account" "electronic_monitoring_case_management_networking_prod" {
  name                       = "Electronic Monitoring Case Management ntwrk prod"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-monitoring-mapping-prod") # Repurposed account
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_electronic_monitoring_case_management.id

  tags = merge(local.tags_electronic_monitoring_case_management, {
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

# Electronic Monitoring Case Management Management prod
resource "aws_organizations_account" "electronic_monitoring_case_management_management_prod" {
  name                       = "Electronic Monitoring Case Management mgmt prod"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-monitoring-mapping-pre-prod") # Repurposed account
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_electronic_monitoring_case_management.id

  tags = merge(local.tags_electronic_monitoring_case_management, {
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
