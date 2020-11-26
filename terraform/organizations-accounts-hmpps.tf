# HMPPS OU
resource "aws_organizations_account" "strategic-partner-gateway-non-production" {
  name      = "Strategic Partner Gateway Non Production"
  email     = local.account_emails["Strategic Partner Gateway Non Production"][0]
  parent_id = aws_organizations_organizational_unit.hmpps.id

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

resource "aws_organizations_account" "probation" {
  name      = "Probation"
  email     = local.account_emails["Probation"][0]
  parent_id = aws_organizations_organizational_unit.hmpps.id

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

resource "aws_organizations_account" "hmpps-management" {
  name      = "HMPPS Management"
  email     = local.account_emails["HMPPS Management"][0]
  parent_id = aws_organizations_organizational_unit.hmpps.id

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

resource "aws_organizations_account" "hmpps-co-financing-organisation" {
  name      = "HMPPS Co-Financing Organisation"
  email     = local.account_emails["HMPPS Co-Financing Organisation"][0]
  parent_id = aws_organizations_organizational_unit.hmpps.id

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

resource "aws_organizations_account" "hmpps-security-audit" {
  name      = "HMPPS Security Audit"
  email     = local.account_emails["HMPPS Security Audit"][0]
  parent_id = aws_organizations_organizational_unit.hmpps.id

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

resource "aws_organizations_account" "hmpps-performance-hub" {
  name      = "HMPPS Performance Hub"
  email     = local.account_emails["HMPPS Performance Hub"][0]
  parent_id = aws_organizations_organizational_unit.hmpps.id

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

resource "aws_organizations_account" "hmpps-prod" {
  name      = "HMPPS PROD"
  email     = local.account_emails["HMPPS PROD"][0]
  parent_id = aws_organizations_organizational_unit.hmpps.id

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

resource "aws_organizations_account" "hmpps-engineering-production" {
  name      = "HMPPS Engineering Production"
  email     = local.account_emails["HMPPS Engineering Production"][0]
  parent_id = aws_organizations_organizational_unit.hmpps.id

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

resource "aws_organizations_account" "hmpps-check-my-diary-prod" {
  name      = "HMPPS Check My Diary Prod"
  email     = local.account_emails["HMPPS Check My Diary Prod"][0]
  parent_id = aws_organizations_organizational_unit.hmpps.id

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

resource "aws_organizations_account" "hmpps-dev" {
  name      = "HMPPS Dev"
  email     = local.account_emails["HMPPS Dev"][0]
  parent_id = aws_organizations_organizational_unit.hmpps.id

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

resource "aws_organizations_account" "noms-api" {
  name      = "NOMS API"
  email     = local.account_emails["NOMS API"][0]
  parent_id = aws_organizations_organizational_unit.hmpps.id

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

resource "aws_organizations_account" "hmpps-security-poc" {
  name      = "HMPPS Security POC"
  email     = local.account_emails["HMPPS Security POC"][0]
  parent_id = aws_organizations_organizational_unit.hmpps.id

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

resource "aws_organizations_account" "hmpps-probation-production" {
  name      = "HMPPS Probation Production"
  email     = local.account_emails["HMPPS Probation Production"][0]
  parent_id = aws_organizations_organizational_unit.hmpps.id

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

resource "aws_organizations_account" "public-sector-prison-industries" {
  name      = "Public Sector Prison Industries"
  email     = local.account_emails["Public Sector Prison Industries"][0]
  parent_id = aws_organizations_organizational_unit.hmpps.id

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

resource "aws_organizations_account" "hmpps-check-my-diary-development" {
  name      = "HMPPS Check My Diary Development"
  email     = local.account_emails["HMPPS Check My Diary Development"][0]
  parent_id = aws_organizations_organizational_unit.hmpps.id

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

