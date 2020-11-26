# CICA OU
resource "aws_organizations_account" "cica" {
  name      = "CICA"
  email     = local.account_emails["CICA"][0]
  parent_id = aws_organizations_organizational_unit.cica.id

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

resource "aws_organizations_policy_attachment" "cica" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.cica.id
}
