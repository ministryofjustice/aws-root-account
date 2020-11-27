# OPG OU: DigiDeps
resource "aws_organizations_account" "opg-digi-deps-prod" {
  name      = "OPG Digi Deps Prod"
  email     = local.account_emails["OPG Digi Deps Prod"][0]
  parent_id = aws_organizations_organizational_unit.opg-digideps.id

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

resource "aws_organizations_policy_attachment" "opg-digi-deps-prod" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.opg-digi-deps-prod.id
}

resource "aws_organizations_account" "opg-digi-deps-dev" {
  name      = "OPG Digi Deps Dev"
  email     = local.account_emails["OPG Digi Deps Dev"][0]
  parent_id = aws_organizations_organizational_unit.opg-digideps.id

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

resource "aws_organizations_policy_attachment" "opg-digi-deps-dev" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.opg-digi-deps-dev.id
}

resource "aws_organizations_account" "opg-digi-deps-preprod" {
  name      = "OPG Digi Deps Preprod"
  email     = local.account_emails["OPG Digi Deps Preprod"][0]
  parent_id = aws_organizations_organizational_unit.opg-digideps.id

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

resource "aws_organizations_policy_attachment" "opg-digi-deps-preprod" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.opg-digi-deps-preprod.id
}
