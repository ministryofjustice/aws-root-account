resource "aws_organizations_account" "money_to_prisoners" {
  name                       = "Money To Prisoners"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "moneytoprisoners")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.closed_accounts.id
  tags                       = {}

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "strategic_partner_gateway_non_production" {
  name                       = "Strategic Partner Gateway Non Production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "spg-non-prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.closed_accounts.id

  tags = merge(local.tags_hmpps, {

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

resource "aws_organizations_account" "security_engineering" {
  name                       = "Security Engineering"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "security_engineering")
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

resource "aws_organizations_account" "delius_new_tech_non_prod" {
  name                       = "Delius New Tech non-prod"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "delius_new_tech_non_prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.closed_accounts.id

  tags = merge(local.tags_delius, {

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

resource "aws_organizations_account" "hmpps_delius_po_test_1" {
  name                       = "HMPPS Delius PO Test 1"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-delius-po-test1")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.closed_accounts.id

  tags = merge(local.tags_delius, {

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

resource "aws_organizations_account" "cloud_networks_psn" {
  name                       = "Cloud Networks PSN"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "cloud_networks_PSN")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.closed_accounts.id

  tags = merge(local.tags_technology_services, {

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

resource "aws_organizations_account" "hmpps_delius_po_test_2" {
  name                       = "HMPPS Delius PO Test 2"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-delius-po-test2")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.closed_accounts.id

  tags = merge(local.tags_delius, {

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

resource "aws_organizations_account" "hmpps_victim_case_management_system_performance" {
  name                       = "HMPPS Victim Case Management System Performance"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-vcms-perf")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.closed_accounts.id

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

resource "aws_organizations_account" "hmpps_victim_case_management_system_stage" {
  name                       = "HMPPS Victim Case Management System Stage"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-vcms-stage")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.closed_accounts.id

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

resource "aws_organizations_account" "hmpps_delius_performance" {
  name                       = "HMPPS Delius Performance"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-delius-performance")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.closed_accounts.id

  tags = merge(local.tags_delius, {

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

resource "aws_organizations_account" "hmpps_delius_training_test" {
  name                       = "HMPPS Delius Training Test"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-delius-training-test")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.closed_accounts.id

  tags = merge(local.tags_delius, {

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

resource "aws_organizations_account" "hmpps_victim_case_management_system_integration" {
  name                       = "HMPPS Victim Case Management System Integration"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-vcms-integration")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.closed_accounts.id

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

resource "aws_organizations_account" "hmpps_delius_mis_test" {
  name                       = "HMPPS Delius MIS Test"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-delius-mis-test")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.closed_accounts.id

  tags = merge(local.tags_delius, {

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
