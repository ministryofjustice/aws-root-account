locals {
  tags_victim_case_management_system = local.tags_business_units.hmpps
}

resource "aws_organizations_account" "hmpps_victim_case_management_system_pre_production" {
  name                       = "HMPPS Victim Case Management System Pre Production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-vcms-pre-prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_vcms.id

  tags = merge(local.tags_victim_case_management_system, {

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

resource "aws_organizations_account" "hmpps_victim_case_management_system_production" {
  name                       = "HMPPS Victim Case Management System Production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-vcms-prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_vcms.id

  tags = merge(local.tags_victim_case_management_system, {

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

resource "aws_organizations_account" "hmpps_victim_case_management_system_test" {
  name                       = "HMPPS Victim Case Management System Test"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-vcms-test")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_vcms.id

  tags = merge(local.tags_victim_case_management_system, {

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

resource "aws_organizations_account" "vcms_non_prod" {
  name                       = "VCMS non-prod"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "vcms_non_prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_vcms.id

  tags = merge(local.tags_victim_case_management_system, {

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
