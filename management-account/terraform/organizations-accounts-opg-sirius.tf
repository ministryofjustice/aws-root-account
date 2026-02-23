resource "aws_organizations_account" "moj_opg_sirius_preproduction" {
  name                       = "MoJ OPG Sirius Preproduction"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "moj-opg-sirius-preproduction")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_sirius.id
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

resource "aws_organizations_account" "opg_sirius_backup" {
  name                       = "OPG Sirius Backup"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "opg-sirius-backup")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_sirius.id
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

resource "aws_organizations_account" "opg_sirius_production" {
  name                       = "OPG Sirius Production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "opg-sirius-prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_sirius.id
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

resource "aws_organizations_account" "opg_sirius_dev" {
  name                       = "opg-sirius-dev"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "opg-sirius-dev")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_sirius.id
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
