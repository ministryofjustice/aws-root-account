resource "aws_organizations_account" "moj_lpa_development" {
  name                       = "MOJ LPA Development"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "moj-lpa-development")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_make_an_lpa.id

  tags = merge(local.tags_opg, {

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

resource "aws_organizations_account" "moj_lpa_preproduction" {
  name                       = "MOJ LPA Preproduction"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "moj-lpa-preproduction")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_make_an_lpa.id

  tags = merge(local.tags_opg, {

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

resource "aws_organizations_account" "moj_opg_lpa_production" {
  name                       = "MOJ OPG LPA Production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "moj-lpa-production")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_make_an_lpa.id

  tags = merge(local.tags_opg, {
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

resource "aws_organizations_account" "opg_lpa_production" {
  name                       = "OPG LPA Production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "opg-lpa-prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_make_an_lpa.id

  tags = merge(local.tags_opg, {
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
