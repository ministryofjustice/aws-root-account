locals {
  tags-analytical-platform = merge(local.tags-business-unit.platforms, {
    application = "Analytical Platform"
  })
}

# Analytical Platform OU
resource "aws_organizations_account" "analytical-platform-development" {
  name      = "Analytical Platform Development"
  email     = local.aws_account_email_addresses["Analytical Platform Development"][0]
  parent_id = aws_organizations_organizational_unit.analytical-platform.id
  tags = merge(local.tags-analytical-platform, {
    environment-name = "development"
  })

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

# Enrol Analytical Platform Development to the restricted regions policy
resource "aws_organizations_policy_attachment" "analytical-platform-development-restricted-regions" {
  policy_id = aws_organizations_policy.deny-non-eu-non-us-east-1-operations.id
  target_id = aws_organizations_account.analytical-platform-development.id
}

resource "aws_organizations_account" "analytics-platform-development" {
  # Note that this account was renamed from "Analytics Platform Development"
  # to Analytical Platform Data Engineering Sandbox, to make it clearer.
  name      = "Analytical Platform Data Engineering Sandbox"
  email     = local.aws_account_email_addresses["Analytical Platform Data Engineering Sandbox"][0]
  parent_id = aws_organizations_organizational_unit.analytical-platform.id
  tags = merge(local.tags-analytical-platform, {
    environment-name = "sandbox"
  })

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

# Enrol Analytical Platform Data Engineering Sandbox to the restricted regions policy
resource "aws_organizations_policy_attachment" "analytics-platform-development-restricted-regions" {
  policy_id = aws_organizations_policy.deny-non-eu-non-us-east-1-operations.id
  target_id = aws_organizations_account.analytics-platform-development.id
}

resource "aws_organizations_account" "analytical-platform-landing" {
  name      = "Analytical Platform Landing"
  email     = local.aws_account_email_addresses["Analytical Platform Landing"][0]
  parent_id = aws_organizations_organizational_unit.analytical-platform.id
  tags = merge(local.tags-analytical-platform, {
    environment-name = "landing"
  })

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

# Enrol Analytical Platform Landing to the restricted regions policy
resource "aws_organizations_policy_attachment" "analytical-platform-landing-restricted-regions" {
  policy_id = aws_organizations_policy.deny-non-eu-non-us-east-1-operations.id
  target_id = aws_organizations_account.analytical-platform-landing.id
}

resource "aws_organizations_account" "analytical-platform-production" {
  name      = "Analytical Platform Production"
  email     = local.aws_account_email_addresses["Analytical Platform Production"][0]
  parent_id = aws_organizations_organizational_unit.analytical-platform.id
  tags = merge(local.tags-analytical-platform, {
    environment-name = "production"
    is-production    = true
  })

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
  parent_id = aws_organizations_organizational_unit.analytical-platform.id
  tags = merge(local.tags-analytical-platform, {
    environment-name = "data-engineering"
  })

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
  parent_id = aws_organizations_organizational_unit.analytical-platform.id
  tags = merge(local.tags-analytical-platform, {
    environment-name = "data"
  })

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
