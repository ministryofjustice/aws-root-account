resource "aws_organizations_account" "opg_use_my_lpa_development" {
  name                       = "OPG Use My LPA Development"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "opg-use-my-lpa-development")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_use_my_lpa.id
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

resource "aws_organizations_account" "opg_use_my_lpa_preproduction" {
  name                       = "OPG Use My LPA Preproduction"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "opg-use-my-lpa-preproduction")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_use_my_lpa.id
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

resource "aws_organizations_account" "opg_use_my_lpa_production" {
  name                       = "OPG Use My LPA Production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "opg-use-my-lpa-production")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_use_my_lpa.id
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
