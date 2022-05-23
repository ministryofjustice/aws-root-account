resource "aws_organizations_account" "aws_laa" {
  name                       = "AWS LAA"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "laa")
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

resource "aws_organizations_account" "platforms_non_production" {
  name                       = "platforms-non-production"
  email                      = local.aws_account_email_addresses["platforms-non-production"][0]
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

resource "aws_organizations_account" "hmpps_check_my_diary_production" {
  name                       = "HMPPS Check My Diary Prod"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-cmd-prod")
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

resource "aws_organizations_account" "hmpps_check_my_diary_development" {
  name                       = "HMPPS Check My Diary Development"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-cmd-dev")
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

resource "aws_organizations_account" "hmpps_delius_po_test" {
  name                       = "HMPPS Delius PO Test"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-delius-po-test")
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

resource "aws_organizations_account" "noms_api" {
  name                       = "NOMS API"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "noms-api")
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

resource "aws_organizations_account" "patterns" {
  name                       = "Patterns"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "patterns")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.closed_accounts.id

  tags = local.tags_central_digital

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "hmpps_security_audit" {
  name                       = "HMPPS Security Audit"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-security-audit")
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

resource "aws_organizations_account" "hmpps_security_poc" {
  name                       = "HMPPS Security POC"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "HMPPS_Security_POC")
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
