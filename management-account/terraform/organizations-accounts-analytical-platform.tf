locals {
  tags_analytical_platform = merge(local.tags_business_units.platforms, {
    application = "Analytical Platform"
  })
}

# Analytical Platform Data Engineering
resource "aws_organizations_account" "analytical_platform_data_engineering" {
  name                       = "analytical-platform-data-engineering"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "analytical-platform-data-engineering")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.analytical_platform.id

  tags = merge(local.tags_analytical_platform, {
    environment-name = "data-engineering"
  })

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

# Analytical Platform Data Engineering Sandbox
resource "aws_organizations_account" "analytical_platform_data_engineering_sandbox" {
  name                       = "analytical-platform-data-engineering-sandbox"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "analytics-platform-dev")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.analytical_platform.id

  tags = merge(local.tags_analytical_platform, {
    environment-name = "data-engineering-sandbox"
  })

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

# Analytical Platform Development
resource "aws_organizations_account" "analytical_platform_development" {
  name                       = "analytical-platform-development"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "analytical-platform-dev")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.analytical_platform.id

  tags = merge(local.tags_analytical_platform, {
    environment-name = "development"
  })

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

# Analytical Platform Landing
resource "aws_organizations_account" "analytical_platform_landing" {
  name                       = "analytical-platform-landing"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "analytical-platform-landing")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.analytical_platform.id

  tags = merge(local.tags_analytical_platform, {
    environment-name = "landing"
  })

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

# Analytical Platform Production
resource "aws_organizations_account" "analytical_platform_production" {
  name                       = "analytical-platform-production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "analytical-platform-prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.analytical_platform.id

  tags = merge(local.tags_analytical_platform, {
    environment-name = "production"
    is-production    = true
  })

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

# MOJ Analytics Platform
resource "aws_organizations_account" "moj_analytics_platform" {
  name                       = "analytical-platform-data-production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "AnalyticsPlatform")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.analytical_platform.id

  tags = merge(local.tags_analytical_platform, {
    environment-name = "data"
  })

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}
