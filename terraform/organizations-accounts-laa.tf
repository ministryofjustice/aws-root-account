# LAA OU
resource "aws_organizations_account" "laa-test" {
  name      = "LAA Test"
  email     = local.aws_account_email_addresses["LAA Test"][0]
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

# Enrol LAA Test to the restricted regions policy
resource "aws_organizations_policy_attachment" "laa-test-restricted-regions" {
  policy_id = aws_organizations_policy.deny-non-eu-non-us-east-1-operations.id
  target_id = aws_organizations_account.laa-test.id
}

resource "aws_organizations_account" "laa-uat" {
  name      = "LAA UAT"
  email     = local.aws_account_email_addresses["LAA UAT"][0]
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

# Enrol LAA UAT to the restricted regions policy
resource "aws_organizations_policy_attachment" "laa-uat-restricted-regions" {
  policy_id = aws_organizations_policy.deny-non-eu-non-us-east-1-operations.id
  target_id = aws_organizations_account.laa-uat.id
}

resource "aws_organizations_account" "aws-laa" {
  name      = "AWS LAA"
  email     = local.aws_account_email_addresses["AWS LAA"][0]
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

# Enrol AWS LAA to the restricted regions policy
resource "aws_organizations_policy_attachment" "aws-laa-restricted-regions" {
  policy_id = aws_organizations_policy.deny-non-eu-non-us-east-1-operations.id
  target_id = aws_organizations_account.aws-laa.id
}

resource "aws_organizations_account" "laa-staging" {
  name      = "LAA Staging"
  email     = local.aws_account_email_addresses["LAA Staging"][0]
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

# Enrol LAA Staging to the restricted regions policy
resource "aws_organizations_policy_attachment" "laa-staging-restricted-regions" {
  policy_id = aws_organizations_policy.deny-non-eu-non-us-east-1-operations.id
  target_id = aws_organizations_account.laa-staging.id
}

resource "aws_organizations_account" "legal-aid-agency" {
  name      = "Legal Aid Agency"
  email     = local.aws_account_email_addresses["Legal Aid Agency"][0]
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

# Enrol LAA Sandbox (Legal Aid Agency) to the restricted regions policy
resource "aws_organizations_policy_attachment" "legal-aid-agency-restricted-regions" {
  policy_id = aws_organizations_policy.deny-non-eu-non-us-east-1-operations.id
  target_id = aws_organizations_account.legal-aid-agency.id
}

resource "aws_organizations_account" "laa-development" {
  name      = "LAA Development"
  email     = local.aws_account_email_addresses["LAA Development"][0]
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

# Enrol LAA Development to the restricted regions policy
resource "aws_organizations_policy_attachment" "laa-development-restricted-regions" {
  policy_id = aws_organizations_policy.deny-non-eu-non-us-east-1-operations.id
  target_id = aws_organizations_account.laa-development.id
}

resource "aws_organizations_account" "laa-cloudtrail" {
  name      = "LAA CloudTrail"
  email     = local.aws_account_email_addresses["LAA CloudTrail"][0]
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

# Enrol LAA CloudTrail to the restricted regions policy
resource "aws_organizations_policy_attachment" "laa-cloudtrail-restricted-regions" {
  policy_id = aws_organizations_policy.deny-non-eu-non-us-east-1-operations.id
  target_id = aws_organizations_account.laa-cloudtrail.id
}

resource "aws_organizations_account" "laa-production" {
  name      = "LAA Production"
  email     = local.aws_account_email_addresses["LAA Production"][0]
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

resource "aws_organizations_account" "laa-shared-services" {
  name      = "LAA Shared services"
  email     = local.aws_account_email_addresses["LAA Shared services"][0]
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
