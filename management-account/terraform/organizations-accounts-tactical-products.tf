locals {
  tags_tactical_products = local.tags_business_units.hq
}

resource "aws_organizations_account" "ministry_of_justice_courtfinder_prod" {
  name                       = "Ministry of Justice Courtfinder Prod"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "courtfinder-prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.tactical_products.id

  tags = local.tags_tactical_products

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "moj_info_services_dev" {
  name                       = "MoJ Info Services Dev"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "courtfinder")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.tactical_products.id

  tags = local.tags_tactical_products

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "tacticalproducts" {
  name                       = "tacticalproducts"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "tacticalproducts")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.tactical_products.id

  tags = local.tags_tactical_products

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "tp_hmcts" {
  name                       = "TP-HMCTS"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "TP-HMCTS")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.tactical_products.id

  tags = local.tags_tactical_products

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}
