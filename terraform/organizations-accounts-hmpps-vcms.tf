# HMPPS OU: VCMS
resource "aws_organizations_account" "hmpps-victim-case-management-system-production" {
  name      = "HMPPS Victim Case Management System Production"
  email     = local.aws_account_email_addresses["HMPPS Victim Case Management System Production"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-vcms.id

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

resource "aws_organizations_policy_attachment" "hmpps-victim-case-management-system-production" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmpps-victim-case-management-system-production.id
}

resource "aws_organizations_account" "hmpps-victim-case-management-system-integration" {
  name      = "HMPPS Victim Case Management System Integration"
  email     = local.aws_account_email_addresses["HMPPS Victim Case Management System Integration"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-vcms.id

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

resource "aws_organizations_policy_attachment" "hmpps-victim-case-management-system-integration" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmpps-victim-case-management-system-integration.id
}

resource "aws_organizations_account" "hmpps-victim-case-management-system-performance" {
  name      = "HMPPS Victim Case Management System Performance"
  email     = local.aws_account_email_addresses["HMPPS Victim Case Management System Performance"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-vcms.id

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

resource "aws_organizations_policy_attachment" "hmpps-victim-case-management-system-performance" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmpps-victim-case-management-system-performance.id
}

resource "aws_organizations_account" "hmpps-victim-case-management-system-test" {
  name      = "HMPPS Victim Case Management System Test"
  email     = local.aws_account_email_addresses["HMPPS Victim Case Management System Test"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-vcms.id

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

resource "aws_organizations_policy_attachment" "hmpps-victim-case-management-system-test" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmpps-victim-case-management-system-test.id
}

resource "aws_organizations_account" "vcms-non-prod" {
  name      = "VCMS non-prod"
  email     = local.aws_account_email_addresses["VCMS non-prod"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-vcms.id

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

resource "aws_organizations_policy_attachment" "vcms-non-prod" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.vcms-non-prod.id
}

resource "aws_organizations_account" "hmpps-victim-case-management-system-pre-production" {
  name      = "HMPPS Victim Case Management System Pre Production"
  email     = local.aws_account_email_addresses["HMPPS Victim Case Management System Pre Production"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-vcms.id

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

resource "aws_organizations_policy_attachment" "hmpps-victim-case-management-system-pre-production" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmpps-victim-case-management-system-pre-production.id
}

resource "aws_organizations_account" "hmpps-victim-case-management-system-stage" {
  name      = "HMPPS Victim Case Management System Stage"
  email     = local.aws_account_email_addresses["HMPPS Victim Case Management System Stage"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-vcms.id

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

resource "aws_organizations_policy_attachment" "hmpps-victim-case-management-system-stage" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmpps-victim-case-management-system-stage.id
}
