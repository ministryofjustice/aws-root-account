resource "aws_organizations_account" "security-operations-development" {
  name      = "Security Operations Development"
  email     = local.aws_account_email_addresses["Security Operations Development"][0]
  parent_id = aws_organizations_organizational_unit.security-engineering.id

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
