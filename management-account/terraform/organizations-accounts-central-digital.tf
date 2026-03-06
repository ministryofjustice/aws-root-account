locals {
  tags_central_digital = merge(local.tags_business_units.hq)
}

resource "aws_organizations_account" "tacticalproducts" {
  name                       = "tacticalproducts"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "tacticalproducts")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.central_digital.id
  close_on_deletion          = true

  tags = local.tags_central_digital

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}
