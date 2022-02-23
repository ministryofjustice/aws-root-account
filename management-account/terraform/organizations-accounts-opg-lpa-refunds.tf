resource "aws_organizations_account" "moj_opg_lpa_refunds_development" {
  name                       = "MOJ OPG LPA Refunds Development"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "moj-refunds-development")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_lpa_refunds.id

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

resource "aws_organizations_account" "moj_opg_lpa_refunds_preproduction" {
  name                       = "MOJ OPG LPA Refunds Preproduction"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "moj-refunds-preproduction")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_lpa_refunds.id

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

resource "aws_organizations_account" "moj_opg_lpa_refunds_production" {
  name                       = "MOJ OPG LPA Refunds Production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "moj-refunds-production")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_lpa_refunds.id

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
  parent_id                  = aws_organizations_organizational_unit.opg_lpa_refunds.id

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
