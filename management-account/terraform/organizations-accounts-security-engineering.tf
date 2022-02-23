locals {
  tags_security = local.tags_business_units.hq
}

resource "aws_organizations_account" "moj_security" {
  name                       = "MoJ Security"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "moj+security")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.security_engineering.id

  tags = local.tags_security

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "security_engineering" {
  name                       = "Security Engineering"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "security_engineering")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.security_engineering.id

  tags = local.tags_security

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "security_logging_platform" {
  name                       = "Security Logging Platform"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "security-logging-platform")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.security_engineering.id

  tags = local.tags_security

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "security_operations_development" {
  name                       = "Security Operations Development"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "secops-dev")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.security_engineering.id

  tags = local.tags_security

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "security_operations_pre_production" {
  name                       = "Security Operations Pre Production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "secops-preprod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.security_engineering.id

  tags = local.tags_security

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "security_operations_production" {
  name                       = "Security Operations Production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "secops-prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.security_engineering.id

  tags = local.tags_security

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}
