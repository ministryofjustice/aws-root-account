# YJB OU
resource "aws_organizations_account" "youth-justice-framework-dev" {
  name      = "Youth Justice Framework Dev"
  email     = local.aws_account_email_addresses["Youth Justice Framework Dev"][0]
  parent_id = aws_organizations_organizational_unit.yjb.id

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

resource "aws_organizations_account" "youth-justice-framework-management" {
  name      = "Youth Justice Framework Management"
  email     = local.aws_account_email_addresses["Youth Justice Framework Management"][0]
  parent_id = aws_organizations_organizational_unit.yjb.id

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

resource "aws_organizations_account" "youth-justice-framework-pre-prod" {
  name      = "Youth Justice Framework Pre-Prod"
  email     = local.aws_account_email_addresses["Youth Justice Framework Pre-Prod"][0]
  parent_id = aws_organizations_organizational_unit.yjb.id

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

resource "aws_organizations_account" "youth-justice-framework-juniper" {
  name      = "Youth Justice Framework Juniper"
  email     = local.aws_account_email_addresses["Youth Justice Framework Juniper"][0]
  parent_id = aws_organizations_organizational_unit.yjb.id

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

resource "aws_organizations_account" "youth-justice-framework-prod" {
  name      = "Youth Justice Framework Prod"
  email     = local.aws_account_email_addresses["Youth Justice Framework Prod"][0]
  parent_id = aws_organizations_organizational_unit.yjb.id

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

resource "aws_organizations_account" "youth-justice-framework-monitoring" {
  name      = "Youth Justice Framework Monitoring"
  email     = local.aws_account_email_addresses["Youth Justice Framework Monitoring"][0]
  parent_id = aws_organizations_organizational_unit.yjb.id

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

resource "aws_organizations_account" "youth-justice-framework-eng-tools" {
  name      = "Youth Justice Framework Eng Tools"
  email     = local.aws_account_email_addresses["Youth Justice Framework Eng Tools"][0]
  parent_id = aws_organizations_organizational_unit.yjb.id

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

resource "aws_organizations_account" "youth-justice-framework-sandpit" {
  name      = "Youth Justice Framework Sandpit"
  email     = local.aws_account_email_addresses["Youth Justice Framework Sandpit"][0]
  parent_id = aws_organizations_organizational_unit.yjb.id

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
