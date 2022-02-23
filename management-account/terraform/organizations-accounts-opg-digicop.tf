resource "aws_organizations_account" "moj_opg_digicop_development" {
  name                       = "MoJ OPG DigiCop Development"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "moj-opg-digicop-development")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_digicop.id

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

resource "aws_organizations_account" "moj_opg_digicop_preproduction" {
  name                       = "MoJ OPG DigiCop Preproduction"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "moj-opg-digicop-preproduction")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_digicop.id

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

resource "aws_organizations_account" "moj_opg_digicop_production" {
  name                       = "MoJ OPG DigiCop Production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "moj-opg-digicop-production")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_digicop.id

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
