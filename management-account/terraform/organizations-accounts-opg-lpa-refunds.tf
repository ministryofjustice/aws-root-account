# legacy account for retaining refunds data
resource "aws_organizations_account" "moj_opg_lpa_refunds_production" {
  name                       = "MOJ OPG LPA Refunds Production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "moj-refunds-production")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.opg_lpa_refunds.id
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
