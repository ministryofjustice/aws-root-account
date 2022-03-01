resource "aws_organizations_account" "youth-justice-framework-management" {
  name      = "Youth Justice Framework Management"
  email     = local.aws_account_email_addresses["Youth Justice Framework Management"][0]
  parent_id = aws_organizations_organizational_unit.yjb.id

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
