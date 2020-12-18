locals {
  tags-organisation-management = {
    business-unit = "Platforms"
    application   = "Organisation Management"
  }
}

# Organisation logging account
resource "aws_organizations_account" "organisation-logging" {
  name      = "organisation-logging"
  email     = replace(local.aws_account_email_addresses_template, "{email}", "organisation-logging")
  parent_id = aws_organizations_organizational_unit.organisation-management.id

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

  tags = merge(
    local.tags-organisation-management, {
      component = "Logging"
    }
  )
}

resource "aws_organizations_policy_attachment" "organisation-logging" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.organisation-logging.id
}

# Organisation security account
resource "aws_organizations_account" "organisation-security" {
  name      = "organisation-security"
  email     = replace(local.aws_account_email_addresses_template, "{email}", "organisation-security")
  parent_id = aws_organizations_organizational_unit.organisation-management.id

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

  tags = merge(
    local.tags-organisation-management, {
      component = "Security"
    }
  )
}

resource "aws_organizations_policy_attachment" "organisation-security" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.organisation-security.id
}
