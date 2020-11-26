# OPG OU: LPA Refunds
resource "aws_organizations_account" "opg-refund-develop" {
  name      = "opg-refund-develop"
  email     = local.account_emails["opg-refund-develop"][0]
  parent_id = aws_organizations_organizational_unit.opg-lpa-refunds.id

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

resource "aws_organizations_policy_attachment" "opg-refund-develop" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.opg-refund-develop.id
}

resource "aws_organizations_account" "opg-refund-production" {
  name      = "opg-refund-production"
  email     = local.account_emails["opg-refund-production"][0]
  parent_id = aws_organizations_organizational_unit.opg-lpa-refunds.id

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

resource "aws_organizations_policy_attachment" "opg-refund-production" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.opg-refund-production.id
}

resource "aws_organizations_account" "moj-opg-lpa-refunds-development" {
  name      = "MOJ OPG LPA Refunds Development"
  email     = local.account_emails["MOJ OPG LPA Refunds Development"][0]
  parent_id = aws_organizations_organizational_unit.opg-lpa-refunds.id

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

resource "aws_organizations_policy_attachment" "moj-opg-lpa-refunds-development" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.moj-opg-lpa-refunds-development.id
}

resource "aws_organizations_account" "moj-opg-lpa-refunds-preproduction" {
  name      = "MOJ OPG LPA Refunds Preproduction"
  email     = local.account_emails["MOJ OPG LPA Refunds Preproduction"][0]
  parent_id = aws_organizations_organizational_unit.opg-lpa-refunds.id

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

resource "aws_organizations_policy_attachment" "moj-opg-lpa-refunds-preproduction" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.moj-opg-lpa-refunds-preproduction.id
}

resource "aws_organizations_account" "moj-opg-lpa-refunds-production" {
  name      = "MOJ OPG LPA Refunds Production"
  email     = local.account_emails["MOJ OPG LPA Refunds Production"][0]
  parent_id = aws_organizations_organizational_unit.opg-lpa-refunds.id

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

resource "aws_organizations_policy_attachment" "moj-opg-lpa-refunds-production" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.moj-opg-lpa-refunds-production.id
}
