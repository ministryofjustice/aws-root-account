# HMPPS OU
resource "aws_organizations_account" "strategic-partner-gateway-non-production" {
  name      = "Strategic Partner Gateway Non Production"
  email     = local.aws_account_email_addresses["Strategic Partner Gateway Non Production"][0]
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

resource "aws_organizations_policy_attachment" "strategic-partner-gateway-non-production" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.strategic-partner-gateway-non-production.id
}

resource "aws_organizations_account" "probation" {
  name      = "Probation"
  email     = local.aws_account_email_addresses["Probation"][0]
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

resource "aws_organizations_policy_attachment" "probation" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.probation.id
}

resource "aws_organizations_account" "hmpps-management" {
  name      = "HMPPS Management"
  email     = local.aws_account_email_addresses["HMPPS Management"][0]
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

resource "aws_organizations_policy_attachment" "hmpps-management" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmpps-management.id
}

resource "aws_organizations_account" "hmpps-co-financing-organisation" {
  name      = "HMPPS Co-Financing Organisation"
  email     = local.aws_account_email_addresses["HMPPS Co-Financing Organisation"][0]
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

resource "aws_organizations_policy_attachment" "hmpps-co-financing-organisation" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmpps-co-financing-organisation.id
}

resource "aws_organizations_account" "hmpps-security-audit" {
  name      = "HMPPS Security Audit"
  email     = local.aws_account_email_addresses["HMPPS Security Audit"][0]
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

resource "aws_organizations_policy_attachment" "hmpps-security-audit" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmpps-security-audit.id
}

resource "aws_organizations_account" "hmpps-performance-hub" {
  name      = "HMPPS Performance Hub"
  email     = local.aws_account_email_addresses["HMPPS Performance Hub"][0]
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

resource "aws_organizations_policy_attachment" "hmpps-performance-hub" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmpps-performance-hub.id
}

resource "aws_organizations_account" "hmpps-prod" {
  name      = "HMPPS PROD"
  email     = local.aws_account_email_addresses["HMPPS PROD"][0]
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

resource "aws_organizations_policy_attachment" "hmpps-prod" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmpps-prod.id
}

resource "aws_organizations_account" "hmpps-engineering-production" {
  name      = "HMPPS Engineering Production"
  email     = local.aws_account_email_addresses["HMPPS Engineering Production"][0]
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

resource "aws_organizations_policy_attachment" "hmpps-engineering-production" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmpps-engineering-production.id
}

resource "aws_organizations_account" "hmpps-check-my-diary-prod" {
  name      = "HMPPS Check My Diary Prod"
  email     = local.aws_account_email_addresses["HMPPS Check My Diary Prod"][0]
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

resource "aws_organizations_policy_attachment" "hmpps-check-my-diary-prod" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmpps-check-my-diary-prod.id
}

resource "aws_organizations_account" "hmpps-dev" {
  name      = "HMPPS Dev"
  email     = local.aws_account_email_addresses["HMPPS Dev"][0]
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

resource "aws_organizations_policy_attachment" "hmpps-dev" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmpps-dev.id
}

resource "aws_organizations_account" "noms-api" {
  name      = "NOMS API"
  email     = local.aws_account_email_addresses["NOMS API"][0]
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

resource "aws_organizations_policy_attachment" "noms-api" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.noms-api.id
}

resource "aws_organizations_account" "hmpps-security-poc" {
  name      = "HMPPS Security POC"
  email     = local.aws_account_email_addresses["HMPPS Security POC"][0]
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

resource "aws_organizations_policy_attachment" "hmpps-security-poc" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmpps-security-poc.id
}

resource "aws_organizations_account" "hmpps-probation-production" {
  name      = "HMPPS Probation Production"
  email     = local.aws_account_email_addresses["HMPPS Probation Production"][0]
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

resource "aws_organizations_policy_attachment" "hmpps-probation-production" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmpps-probation-production.id
}

resource "aws_organizations_account" "public-sector-prison-industries" {
  name      = "Public Sector Prison Industries"
  email     = local.aws_account_email_addresses["Public Sector Prison Industries"][0]
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

resource "aws_organizations_policy_attachment" "public-sector-prison-industries" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.public-sector-prison-industries.id
}

resource "aws_organizations_account" "hmpps-check-my-diary-development" {
  name      = "HMPPS Check My Diary Development"
  email     = local.aws_account_email_addresses["HMPPS Check My Diary Development"][0]
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

resource "aws_organizations_policy_attachment" "hmpps-check-my-diary-development" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmpps-check-my-diary-development.id
}

