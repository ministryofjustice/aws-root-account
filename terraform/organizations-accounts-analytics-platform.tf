# Analytics Platform OU
resource "aws_organizations_account" "analytical-platform-development" {
  name      = "Analytical Platform Development"
  email     = local.aws_account_email_addresses["Analytical Platform Development"][0]
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

resource "aws_organizations_account" "analytics-platform-development" {
  # Note that this account was renamed from "Analytics Platform Development"
  # to Analytical Platform Data Engineering Sandbox, to make it clearer.
  name      = "Analytical Platform Data Engineering Sandbox"
  email     = local.aws_account_email_addresses["Analytical Platform Data Engineering Sandbox"][0]
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

resource "aws_organizations_account" "analytical-platform-landing" {
  name      = "Analytical Platform Landing"
  email     = local.aws_account_email_addresses["Analytical Platform Landing"][0]
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

resource "aws_organizations_account" "analytical-platform-production" {
  name      = "Analytical Platform Production"
  email     = local.aws_account_email_addresses["Analytical Platform Production"][0]
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

resource "aws_organizations_account" "analytical-platform-data-engineering" {
  name      = "Analytical Platform Data Engineering"
  email     = local.aws_account_email_addresses["Analytical Platform Data Engineering"][0]
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

resource "aws_organizations_account" "moj-analytics-platform" {
  name      = "MoJ Analytics Platform"
  email     = local.aws_account_email_addresses["MoJ Analytics Platform"][0]
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
