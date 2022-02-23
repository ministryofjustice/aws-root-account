resource "aws_organizations_account" "opg_digi_deps_dev" {
  name                       = "OPG Digi Deps Dev"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "opg-digideps-dev")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_digideps.id

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

resource "aws_organizations_account" "opg_digi_deps_preprod" {
  name                       = "OPG Digi Deps Preprod"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "opg-digideps-preproduction")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_digideps.id

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

resource "aws_organizations_account" "opg_digi_deps_prod" {
  name                       = "OPG Digi Deps Prod"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "opg-digideps-prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_digideps.id

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
