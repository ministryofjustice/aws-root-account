resource "aws_organizations_account" "moj-opg-identity-closed-0" {
  name      = "MoJ OPG Identity"
  email     = local.aws_account_email_addresses["MoJ OPG Identity"][0]
  parent_id = aws_organizations_organizational_unit.closed-accounts.id

  lifecycle {
    # If any of these attributes are changed, it attempts to destroy and recreate the account,
    # so we should ignore the changes to prevent this from happening.
    ignore_changes = [
      name,
      email,
      iam_user_access_to_billing,
      role_name
    ]
  }
}

resource "aws_organizations_policy_attachment" "moj-opg-identity-closed-0" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.moj-opg-identity-closed-0.id
}

resource "aws_organizations_account" "moj-opg-identity-closed-2" {
  name      = "MoJ OPG Identity"
  email     = local.aws_account_email_addresses["MoJ OPG Identity"][1]
  parent_id = aws_organizations_organizational_unit.closed-accounts.id

  lifecycle {
    # If any of these attributes are changed, it attempts to destroy and recreate the account,
    # so we should ignore the changes to prevent this from happening.
    ignore_changes = [
      name,
      email,
      iam_user_access_to_billing,
      role_name
    ]
  }
}

resource "aws_organizations_policy_attachment" "moj-opg-identity-closed-2" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.moj-opg-identity-closed-2.id
}

resource "aws_organizations_account" "money-to-prisoners-closed" {
  name      = "Money To Prisoners"
  email     = local.aws_account_email_addresses["Money To Prisoners"][0]
  parent_id = aws_organizations_organizational_unit.closed-accounts.id

  lifecycle {
    # If any of these attributes are changed, it attempts to destroy and recreate the account,
    # so we should ignore the changes to prevent this from happening.
    ignore_changes = [
      name,
      email,
      iam_user_access_to_billing,
      role_name
    ]
  }
}

resource "aws_organizations_policy_attachment" "money-to-prisoners-closed" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.money-to-prisoners-closed.id
}

resource "aws_organizations_account" "moj-security-closed" {
  name      = "MoJ-Security"
  email     = local.aws_account_email_addresses["MoJ-Security"][0]
  parent_id = aws_organizations_organizational_unit.closed-accounts.id

  lifecycle {
    # If any of these attributes are changed, it attempts to destroy and recreate the account,
    # so we should ignore the changes to prevent this from happening.
    ignore_changes = [
      name,
      email,
      iam_user_access_to_billing,
      role_name
    ]
  }
}

resource "aws_organizations_policy_attachment" "moj-security-closed" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.moj-security-closed.id
}
