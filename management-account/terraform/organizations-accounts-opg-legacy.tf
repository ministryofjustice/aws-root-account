resource "aws_organizations_account" "opg_lpa_production" {
  name                       = "OPG LPA Production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "opg-lpa-prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_legacy.id
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

resource "aws_organizations_account" "opg_refund_production" {
  name                       = "opg-refund-production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "opg-refund-production")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_legacy.id
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

resource "aws_organizations_account" "opg_shared" {
  name                       = "opg-shared"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "opg-shared")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_legacy.id
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
