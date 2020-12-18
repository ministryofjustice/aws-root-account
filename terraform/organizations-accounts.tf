# Accounts that sit within the root OU. This doesn't include the actual root account.
resource "aws_organizations_account" "bichard7-2020-prototype" {
  name      = "Bichard7 2020 Prototype"
  email     = local.aws_account_email_addresses["Bichard7 2020 Prototype"][0]
  parent_id = aws_organizations_organization.default.roots[0].id

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

resource "aws_organizations_policy_attachment" "bichard7-2020-prototype" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.bichard7-2020-prototype.id
}

resource "aws_organizations_account" "moj-billing-management" {
  name      = "MoJ Billing Management"
  email     = local.aws_account_email_addresses["MoJ Billing Management"][0]
  parent_id = aws_organizations_organization.default.roots[0].id

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

resource "aws_organizations_policy_attachment" "moj-billing-management" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.moj-billing-management.id
}
