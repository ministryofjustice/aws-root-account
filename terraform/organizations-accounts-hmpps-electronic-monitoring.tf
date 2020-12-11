locals {
  tags-hmpps-em = {
    business-unit = "HMPPS"
    application   = "Electronic Monitoring"
  }
}

# HMPPS OU: Electronic Monitoring
resource "aws_organizations_account" "electronic-monitoring-monitoring-mapping-dev" {
  name      = "Electronic Monitoring Monitoring&Mapping Dev"
  email     = local.account_emails["Electronic Monitoring Monitoring&Mapping Dev"][0]
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

resource "aws_organizations_policy_attachment" "electronic-monitoring-monitoring-mapping-dev" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.electronic-monitoring-monitoring-mapping-dev.id
}

resource "aws_organizations_account" "electronic-monitoring-shared-logging" {
  name      = "Electronic Monitoring Shared Logging"
  email     = local.account_emails["Electronic Monitoring Shared Logging"][0]
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

resource "aws_organizations_policy_attachment" "electronic-monitoring-shared-logging" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.electronic-monitoring-shared-logging.id
}

resource "aws_organizations_account" "electronic-monitoring-tagging-hardware-pre-prod" {
  name      = "Electronic Monitoring Tagging Hardware Pre-Prod"
  email     = local.account_emails["Electronic Monitoring Tagging Hardware Pre-Prod"][0]
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

resource "aws_organizations_policy_attachment" "electronic-monitoring-tagging-hardware-pre-prod" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.electronic-monitoring-tagging-hardware-pre-prod.id
}

resource "aws_organizations_account" "electronic-monitoring-shared-networking-non-prod" {
  name      = "Electronic Monitoring Shared Networking (non-prod)"
  email     = local.account_emails["Electronic Monitoring Shared Networking (non-prod)"][0]
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

resource "aws_organizations_policy_attachment" "electronic-monitoring-shared-networking-non-prod" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.electronic-monitoring-shared-networking-non-prod.id
}

resource "aws_organizations_account" "electronic-monitoring-tagging-hardware-prod" {
  name      = "Electronic Monitoring Tagging Hardware Prod"
  email     = local.account_emails["Electronic Monitoring Tagging Hardware Prod"][0]
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

resource "aws_organizations_policy_attachment" "electronic-monitoring-tagging-hardware-prod" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.electronic-monitoring-tagging-hardware-prod.id
}

resource "aws_organizations_account" "electronic-monitoring-monitoring-mapping-pre-prod" {
  name      = "Electronic Monitoring Monitoring&Mapping Pre-Prod"
  email     = local.account_emails["Electronic Monitoring Monitoring&Mapping Pre-Prod"][0]
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

resource "aws_organizations_policy_attachment" "electronic-monitoring-monitoring-mapping-pre-prod" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.electronic-monitoring-monitoring-mapping-pre-prod.id
}

resource "aws_organizations_account" "electronic-monitoring-identity-access-management" {
  name      = "Electronic Monitoring Identity & Access Management"
  email     = local.account_emails["Electronic Monitoring Identity & Access Management"][0]
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

resource "aws_organizations_policy_attachment" "electronic-monitoring-identity-access-management" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.electronic-monitoring-identity-access-management.id
}

resource "aws_organizations_account" "electronic-monitoring-monitoring-mapping-test" {
  name      = "Electronic Monitoring Monitoring&Mapping Test"
  email     = local.account_emails["Electronic Monitoring Monitoring&Mapping Test"][0]
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

resource "aws_organizations_policy_attachment" "electronic-monitoring-monitoring-mapping-test" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.electronic-monitoring-monitoring-mapping-test.id
}

resource "aws_organizations_account" "electronic-monitoring-shared-networking" {
  name      = "Electronic Monitoring Shared Networking"
  email     = local.account_emails["Electronic Monitoring Shared Networking"][0]
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

resource "aws_organizations_policy_attachment" "electronic-monitoring-shared-networking" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.electronic-monitoring-shared-networking.id
}

resource "aws_organizations_account" "electronic-monitoring-tagging-hardware-test" {
  name      = "Electronic Monitoring Tagging Hardware Test"
  email     = local.account_emails["Electronic Monitoring Tagging Hardware Test"][0]
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

resource "aws_organizations_policy_attachment" "electronic-monitoring-tagging-hardware-test" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.electronic-monitoring-tagging-hardware-test.id
}

resource "aws_organizations_account" "electronic-monitoring-protective-monitoring" {
  name      = "Electronic Monitoring Protective Monitoring"
  email     = local.account_emails["Electronic Monitoring Protective Monitoring"][0]
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

resource "aws_organizations_policy_attachment" "electronic-monitoring-protective-monitoring" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.electronic-monitoring-protective-monitoring.id
}

resource "aws_organizations_account" "electronic-monitoring-archive-query-service" {
  name      = "Electronic Monitoring Archive & Query Service"
  email     = local.account_emails["Electronic Monitoring Archive & Query Service"][0]
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

resource "aws_organizations_policy_attachment" "electronic-monitoring-archive-query-service" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.electronic-monitoring-archive-query-service.id
}

resource "aws_organizations_account" "electronic-monitoring-monitoring-mapping-prod" {
  name      = "Electronic Monitoring Monitoring&Mapping Prod"
  email     = local.account_emails["Electronic Monitoring Monitoring&Mapping Prod"][0]
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

resource "aws_organizations_policy_attachment" "electronic-monitoring-monitoring-mapping-prod" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.electronic-monitoring-monitoring-mapping-prod.id
}

resource "aws_organizations_account" "electronic-monitoring-infrastructure-dev" {
  name      = "Electronic Monitoring Infrastructure Dev"
  email     = local.account_emails["Electronic Monitoring Infrastructure Dev"][0]
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

resource "aws_organizations_policy_attachment" "electronic-monitoring-infrastructure-dev" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.electronic-monitoring-infrastructure-dev.id
}
