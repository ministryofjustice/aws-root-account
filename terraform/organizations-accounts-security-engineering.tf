# Security Engineering OU
resource "aws_organizations_account" "security-operations-production" {
  name      = "Security Operations Production"
  email     = local.account_emails["Security Operations Production"][0]
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

resource "aws_organizations_account" "security-engineering" {
  name      = "Security Engineering"
  email     = local.account_emails["Security Engineering"][0]
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

resource "aws_organizations_account" "security-operations-development" {
  name      = "Security Operations Development"
  email     = local.account_emails["Security Operations Development"][0]
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

resource "aws_organizations_account" "security-logging-platform" {
  name      = "Security Logging Platform"
  email     = local.account_emails["Security Logging Platform"][0]
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

resource "aws_organizations_account" "moj-security" {
  name      = "MoJ Security"
  email     = local.account_emails["MoJ Security"][0]
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

resource "aws_organizations_account" "security-operations-pre-production" {
  name      = "Security Operations Pre Production"
  email     = local.account_emails["Security Operations Pre Production"][0]
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
