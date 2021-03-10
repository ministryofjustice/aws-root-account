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
