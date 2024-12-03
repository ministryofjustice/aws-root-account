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
