# The Modernisation Platform manage their own sub-OUs and sub-accounts.
# The account listed here is their landing account.
# See: https://github.com/ministryofjustice/modernisation-platform

locals {
  tags-modernisation-platform = {
    business-unit = "Platforms"
  }
}

resource "aws_organizations_account" "modernisation-platform" {
  name      = "Modernisation Platform"
  email     = local.aws_account_email_addresses["Modernisation Platform"][0]
  parent_id = aws_organizations_organizational_unit.platforms-and-architecture-modernisation-platform.id

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

  tags = local.tags-modernisation-platform
}

resource "aws_organizations_policy_attachment" "modernisation-platform" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.modernisation-platform.id
}
