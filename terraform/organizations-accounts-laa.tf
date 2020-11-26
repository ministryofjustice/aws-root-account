# LAA OU
resource "aws_organizations_account" "laa-test" {
  name      = "LAA Test"
  email     = local.account_emails["LAA Test"][0]
  parent_id = aws_organizations_organizational_unit.laa.id

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

resource "aws_organizations_policy_attachment" "laa-test" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.laa-test.id
}

resource "aws_organizations_account" "laa-uat" {
  name      = "LAA UAT"
  email     = local.account_emails["LAA UAT"][0]
  parent_id = aws_organizations_organizational_unit.laa.id

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

resource "aws_organizations_policy_attachment" "laa-uat" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.laa-uat.id
}

resource "aws_organizations_account" "aws-laa" {
  name      = "AWS LAA"
  email     = local.account_emails["AWS LAA"][0]
  parent_id = aws_organizations_organizational_unit.laa.id

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

resource "aws_organizations_policy_attachment" "aws-laa" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.aws-laa.id
}

resource "aws_organizations_account" "laa-staging" {
  name      = "LAA Staging"
  email     = local.account_emails["LAA Staging"][0]
  parent_id = aws_organizations_organizational_unit.laa.id

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

resource "aws_organizations_policy_attachment" "laa-staging" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.laa-staging.id
}

resource "aws_organizations_account" "legal-aid-agency" {
  name      = "Legal Aid Agency"
  email     = local.account_emails["Legal Aid Agency"][0]
  parent_id = aws_organizations_organizational_unit.laa.id

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

resource "aws_organizations_policy_attachment" "legal-aid-agency" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.legal-aid-agency.id
}

resource "aws_organizations_account" "laa-development" {
  name      = "LAA Development"
  email     = local.account_emails["LAA Development"][0]
  parent_id = aws_organizations_organizational_unit.laa.id

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

resource "aws_organizations_policy_attachment" "laa-development" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.laa-development.id
}

resource "aws_organizations_account" "laa-cloudtrail" {
  name      = "LAA CloudTrail"
  email     = local.account_emails["LAA CloudTrail"][0]
  parent_id = aws_organizations_organizational_unit.laa.id

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

resource "aws_organizations_policy_attachment" "laa-cloudtrail" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.laa-cloudtrail.id
}

resource "aws_organizations_account" "laa-production" {
  name      = "LAA Production"
  email     = local.account_emails["LAA Production"][0]
  parent_id = aws_organizations_organizational_unit.laa.id

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

resource "aws_organizations_policy_attachment" "laa-production" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.laa-production.id
}

resource "aws_organizations_account" "laa-shared-services" {
  name      = "LAA Shared services"
  email     = local.account_emails["LAA Shared services"][0]
  parent_id = aws_organizations_organizational_unit.laa.id

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

resource "aws_organizations_policy_attachment" "laa-shared-services" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.laa-shared-services.id
}
