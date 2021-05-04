# OPG OU: DigiDeps
resource "aws_organizations_account" "opg-digi-deps-prod" {
  name      = "OPG Digi Deps Prod"
  email     = local.aws_account_email_addresses["OPG Digi Deps Prod"][0]
  parent_id = aws_organizations_organizational_unit.opg-digideps.id
  tags = merge(local.tags-opg, {
    application   = "Complete the deputy report/DigiDeps"
    is-production = true
  })

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

resource "aws_organizations_account" "opg-digi-deps-dev" {
  name      = "OPG Digi Deps Dev"
  email     = local.aws_account_email_addresses["OPG Digi Deps Dev"][0]
  parent_id = aws_organizations_organizational_unit.opg-digideps.id
  tags = merge(local.tags-opg, {
    application = "Complete the deputy report/DigiDeps"
  })

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

# Enrol DigiDeps development to the restricted regions policy
resource "aws_organizations_policy_attachment" "opg-digi-deps-dev-restricted-regions" {
  policy_id = aws_organizations_policy.deny-non-eu-non-us-east-1-operations.id
  target_id = aws_organizations_account.opg-digi-deps-dev.id
}

resource "aws_organizations_account" "opg-digi-deps-preprod" {
  name      = "OPG Digi Deps Preprod"
  email     = local.aws_account_email_addresses["OPG Digi Deps Preprod"][0]
  parent_id = aws_organizations_organizational_unit.opg-digideps.id
  tags = merge(local.tags-opg, {
    application = "Complete the deputy report/DigiDeps"
  })

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
