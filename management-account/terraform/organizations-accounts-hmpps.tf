locals {
  tags_hmpps = local.tags_business_units.hmpps
}

resource "aws_organizations_account" "hmpps_co_financing_organisation" {
  name                       = "HMPPS Co-Financing Organisation"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-co-financing-org")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps.id

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

resource "aws_organizations_account" "hmpps_dev" {
  name                       = "HMPPS Dev"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-dev")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps.id

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

resource "aws_organizations_account" "hmpps_engineering_production" {
  name                       = "HMPPS Engineering Production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-engineering-prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps.id

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

resource "aws_organizations_account" "hmpps_management" {
  name                       = "HMPPS Management"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-mgmt")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps.id

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

resource "aws_organizations_account" "hmpps_performance_hub" {
  name                       = "HMPPS Performance Hub"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-performance-hub")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps.id

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

resource "aws_organizations_account" "hmpps_probation_production" {
  name                       = "HMPPS Probation Production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-probation-prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps.id

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

resource "aws_organizations_account" "hmpps_prod" {
  name                       = "HMPPS PROD"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps.id

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

resource "aws_organizations_account" "hmpps_security_audit" {
  name                       = "HMPPS Security Audit"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-security-audit")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps.id

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
  parent_id                  = aws_organizations_organizational_unit.hmpps.id

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

resource "aws_organizations_account" "noms_api" {
  name                       = "NOMS API"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "noms-api")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps.id

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

resource "aws_organizations_account" "probation" {
  name                       = "Probation"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "probation")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps.id

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

resource "aws_organizations_account" "public_sector_prison_industries" {
  name                       = "Public Sector Prison Industries"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "pspi")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps.id

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
  parent_id                  = aws_organizations_organizational_unit.hmpps.id

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
