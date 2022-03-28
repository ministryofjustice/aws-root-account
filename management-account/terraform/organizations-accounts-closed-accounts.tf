resource "aws_organizations_account" "aws_laa" {
  name                       = "AWS LAA"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "laa")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.closed_accounts.id
  tags                       = {}

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "money_to_prisoners" {
  name                       = "Money To Prisoners"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "moneytoprisoners")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.closed_accounts.id
  tags                       = {}

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "platforms_non_production" {
  name                       = "platforms-non-production"
  email                      = local.aws_account_email_addresses["platforms-non-production"][0]
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.closed_accounts.id
  tags                       = {}

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}
