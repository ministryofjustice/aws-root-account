# Analytics Platform OU
resource "aws_organizations_account" "analytical-platform-development" {
  name      = "Analytical Platform Development"
  email     = local.account_emails["Analytical Platform Development"][0]
  parent_id = aws_organizations_organizational_unit.analytics-platform.id

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

resource "aws_organizations_policy_attachment" "analytical-platform-development" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.analytical-platform-development.id
}

resource "aws_organizations_account" "analytics-platform-development" {
  name      = "Analytics Platform Development"
  email     = local.account_emails["Analytics Platform Development"][0]
  parent_id = aws_organizations_organizational_unit.analytics-platform.id

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

resource "aws_organizations_policy_attachment" "analytics-platform-development" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.analytics-platform-development.id
}

resource "aws_organizations_account" "analytical-platform-landing" {
  name      = "Analytical Platform Landing"
  email     = local.account_emails["Analytical Platform Landing"][0]
  parent_id = aws_organizations_organizational_unit.analytics-platform.id

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

resource "aws_organizations_policy_attachment" "analytical-platform-landing" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.analytical-platform-landing.id
}

resource "aws_organizations_account" "analytical-platform-production" {
  name      = "Analytical Platform Production"
  email     = local.account_emails["Analytical Platform Production"][0]
  parent_id = aws_organizations_organizational_unit.analytics-platform.id

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

resource "aws_organizations_policy_attachment" "analytical-platform-production" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.analytical-platform-production.id
}

resource "aws_organizations_account" "analytical-platform-data-engineering" {
  name      = "Analytical Platform Data Engineering"
  email     = local.account_emails["Analytical Platform Data Engineering"][0]
  parent_id = aws_organizations_organizational_unit.analytics-platform.id

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

resource "aws_organizations_policy_attachment" "analytical-platform-data-engineering" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.analytical-platform-data-engineering.id
}

resource "aws_organizations_account" "moj-analytics-platform" {
  name      = "MoJ Analytics Platform"
  email     = local.account_emails["MoJ Analytics Platform"][0]
  parent_id = aws_organizations_organizational_unit.analytics-platform.id

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

resource "aws_organizations_policy_attachment" "moj-analytics-platform" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.moj-analytics-platform.id
}
