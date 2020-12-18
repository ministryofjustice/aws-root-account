# AWS accounts for CICA
locals {
  tags-cica = {
    business-unit = "CICA"
  }
}

resource "aws_organizations_account" "cica" {
  name      = "CICA"
  email     = local.aws_account_email_addresses["CICA"][0]
  parent_id = aws_organizations_organizational_unit.cica.id

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

  tags = local.tags-cica
}

resource "aws_organizations_policy_attachment" "cica" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.cica.id
}

resource "aws_organizations_account" "cica-development" {
  name      = "CICA Development"
  email     = local.aws_account_email_addresses["CICA Development"][0]
  parent_id = aws_organizations_organizational_unit.cica.id

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

  tags = local.tags-cica
}

resource "aws_organizations_policy_attachment" "cica-development" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.cica-development.id
}

resource "aws_organizations_account" "cica-test-verify" {
  name      = "CICA Test & Verify"
  email     = local.aws_account_email_addresses["CICA Test & Verify"][0]
  parent_id = aws_organizations_organizational_unit.cica.id

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

  tags = local.tags-cica
}

resource "aws_organizations_policy_attachment" "cica-test-verify" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.cica-test-verify.id
}

resource "aws_organizations_account" "cica-uat" {
  name      = "CICA UAT"
  email     = local.aws_account_email_addresses["CICA UAT"][0]
  parent_id = aws_organizations_organizational_unit.cica.id

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

  tags = local.tags-cica
}

resource "aws_organizations_policy_attachment" "cica-uat" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.cica-uat.id
}
