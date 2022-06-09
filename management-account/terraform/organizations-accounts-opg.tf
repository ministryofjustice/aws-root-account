locals {
  tags_opg = local.tags_business_units.opg
}

resource "aws_organizations_account" "moj_opg_identity" {
  name                       = "MoJ OPG Identity"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "moj-opg-identity")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg.id

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

resource "aws_organizations_account" "moj_opg_management" {
  name                       = "MoJ OPG Management"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "moj-opg-management")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg.id

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

resource "aws_organizations_account" "moj_opg_sandbox" {
  name                       = "MoJ OPG Sandbox"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "moj-opg-sandbox")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg.id

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

resource "aws_organizations_account" "moj_opg_shared_development" {
  name                       = "MoJ OPG Shared Development"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "moj-opg-shared-dev")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg.id

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

resource "aws_organizations_account" "moj_opg_shared_production" {
  name                       = "MoJ OPG Shared Production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "moj-opg-shared-prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg.id

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

resource "aws_organizations_account" "opg_backups" {
  name                       = "OPG Backups"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "opg-backups")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg.id

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
