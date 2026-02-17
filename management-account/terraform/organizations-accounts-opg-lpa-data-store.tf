# Repurposed for LPA Data Store, was LPA Refunds Development
moved {
  from = aws_organizations_account.moj_opg_lpa_refunds_development
  to   = aws_organizations_account.moj_opg_lpa_data_store_preproduction
}

resource "aws_organizations_account" "moj_opg_lpa_data_store_preproduction" {
  name                       = "opg-lpa-data-store-preproduction"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "opg-lpa-store-preproduction")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_lpa_data_store.id
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

# Repurposed for LPA Data Store, was LPA Refunds Preproduction
moved {
  from = aws_organizations_account.moj_opg_lpa_refunds_preproduction
  to   = aws_organizations_account.moj_opg_lpa_data_store_production
}
resource "aws_organizations_account" "moj_opg_lpa_data_store_production" {
  name                       = "opg-lpa-data-store-production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "opg-lpa-store-production")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_lpa_data_store.id
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
