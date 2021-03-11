locals {
  tags-hmpps-em = {
    business-unit = "HMPPS"
    application   = "Electronic Monitoring"
  }
}

# HMPPS OU: Electronic Monitoring
resource "aws_organizations_account" "electronic-monitoring-monitoring-mapping-dev" {
  name      = "Electronic Monitoring Monitoring&Mapping Dev"
  email     = local.aws_account_email_addresses["Electronic Monitoring Monitoring&Mapping Dev"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-electronic-monitoring.id

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

  tags = local.tags-hmpps-em
}

resource "aws_organizations_account" "electronic-monitoring-shared-logging" {
  name      = "Electronic Monitoring Shared Logging"
  email     = local.aws_account_email_addresses["Electronic Monitoring Shared Logging"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-electronic-monitoring.id

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

  tags = local.tags-hmpps-em
}

resource "aws_organizations_account" "electronic-monitoring-tagging-hardware-pre-prod" {
  name      = "Electronic Monitoring Tagging Hardware Pre-Prod"
  email     = local.aws_account_email_addresses["Electronic Monitoring Tagging Hardware Pre-Prod"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-electronic-monitoring.id

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

  tags = local.tags-hmpps-em
}

resource "aws_organizations_account" "electronic-monitoring-shared-networking-non-prod" {
  name      = "Electronic Monitoring Shared Networking (non-prod)"
  email     = local.aws_account_email_addresses["Electronic Monitoring Shared Networking (non-prod)"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-electronic-monitoring.id

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

  tags = local.tags-hmpps-em
}

resource "aws_organizations_account" "electronic-monitoring-tagging-hardware-prod" {
  name      = "Electronic Monitoring Tagging Hardware Prod"
  email     = local.aws_account_email_addresses["Electronic Monitoring Tagging Hardware Prod"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-electronic-monitoring.id

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

  tags = local.tags-hmpps-em
}

resource "aws_organizations_account" "electronic-monitoring-monitoring-mapping-pre-prod" {
  name      = "Electronic Monitoring Monitoring&Mapping Pre-Prod"
  email     = local.aws_account_email_addresses["Electronic Monitoring Monitoring&Mapping Pre-Prod"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-electronic-monitoring.id

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

  tags = local.tags-hmpps-em
}

resource "aws_organizations_account" "electronic-monitoring-identity-access-management" {
  name      = "Electronic Monitoring Identity & Access Management"
  email     = local.aws_account_email_addresses["Electronic Monitoring Identity & Access Management"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-electronic-monitoring.id

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

  tags = local.tags-hmpps-em
}

resource "aws_organizations_account" "electronic-monitoring-monitoring-mapping-test" {
  name      = "Electronic Monitoring Monitoring&Mapping Test"
  email     = local.aws_account_email_addresses["Electronic Monitoring Monitoring&Mapping Test"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-electronic-monitoring.id

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

  tags = local.tags-hmpps-em
}

resource "aws_organizations_account" "electronic-monitoring-shared-networking" {
  name      = "Electronic Monitoring Shared Networking"
  email     = local.aws_account_email_addresses["Electronic Monitoring Shared Networking"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-electronic-monitoring.id

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

  tags = local.tags-hmpps-em
}

resource "aws_organizations_account" "electronic-monitoring-tagging-hardware-test" {
  name      = "Electronic Monitoring Tagging Hardware Test"
  email     = local.aws_account_email_addresses["Electronic Monitoring Tagging Hardware Test"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-electronic-monitoring.id

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

  tags = local.tags-hmpps-em
}

resource "aws_organizations_account" "electronic-monitoring-protective-monitoring" {
  name      = "Electronic Monitoring Protective Monitoring"
  email     = local.aws_account_email_addresses["Electronic Monitoring Protective Monitoring"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-electronic-monitoring.id

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

  tags = local.tags-hmpps-em
}

resource "aws_organizations_account" "electronic-monitoring-archive-query-service" {
  name      = "Electronic Monitoring Archive & Query Service"
  email     = local.aws_account_email_addresses["Electronic Monitoring Archive & Query Service"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-electronic-monitoring.id

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

  tags = local.tags-hmpps-em
}

resource "aws_organizations_account" "electronic-monitoring-monitoring-mapping-prod" {
  name      = "Electronic Monitoring Monitoring&Mapping Prod"
  email     = local.aws_account_email_addresses["Electronic Monitoring Monitoring&Mapping Prod"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-electronic-monitoring.id

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

  tags = local.tags-hmpps-em
}

resource "aws_organizations_account" "electronic-monitoring-infrastructure-dev" {
  name      = "Electronic Monitoring Infrastructure Dev"
  email     = local.aws_account_email_addresses["Electronic Monitoring Infrastructure Dev"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-electronic-monitoring.id

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

  tags = local.tags-hmpps-em
}
