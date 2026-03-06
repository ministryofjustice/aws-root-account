resource "aws_organizations_account" "opg_modernising_lpa_development" {
  name                       = "OPG Modernising LPA Development"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "modernisinglpa+development")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_modernising_lpa.id
  close_on_deletion          = true

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

resource "aws_organizations_account" "opg_modernising_lpa_preproduction" {
  name                       = "OPG Modernising LPA PreProduction"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "modernisinglpa+preproduction")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_modernising_lpa.id
  close_on_deletion          = true

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

resource "aws_organizations_account" "opg_modernising_lpa_production" {
  name                       = "OPG Modernising LPA Production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "modernisinglpa+production")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_modernising_lpa.id
  close_on_deletion          = true

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
