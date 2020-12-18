# HMCTS OU
resource "aws_organizations_account" "hmcts-fee-remissions" {
  name      = "HMCTS Fee Remissions"
  email     = local.aws_account_email_addresses["HMCTS Fee Remissions"][0]
  parent_id = aws_organizations_organizational_unit.hmcts.id

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

resource "aws_organizations_policy_attachment" "hmcts-fee-remissions" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmcts-fee-remissions.id
}

resource "aws_organizations_account" "manchester-traffic-dev" {
  name      = "Manchester Traffic Dev"
  email     = local.aws_account_email_addresses["Manchester Traffic Dev"][0]
  parent_id = aws_organizations_organizational_unit.hmcts.id

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

resource "aws_organizations_policy_attachment" "manchester-traffic-dev" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.manchester-traffic-dev.id
}

resource "aws_organizations_account" "get-help-with-child-arrangements" {
  name      = "Get help with child arrangements"
  email     = local.aws_account_email_addresses["Get help with child arrangements"][0]
  parent_id = aws_organizations_organizational_unit.hmcts.id

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

resource "aws_organizations_policy_attachment" "get-help-with-child-arrangements" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.get-help-with-child-arrangements.id
}
