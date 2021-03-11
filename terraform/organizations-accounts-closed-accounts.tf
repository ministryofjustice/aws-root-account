resource "aws_organizations_account" "money-to-prisoners-closed" {
  name      = "Money To Prisoners"
  email     = local.aws_account_email_addresses["Money To Prisoners"][0]
  parent_id = aws_organizations_organizational_unit.closed-accounts.id

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

resource "aws_organizations_account" "moj-security-closed" {
  name      = "MoJ-Security"
  email     = local.aws_account_email_addresses["MoJ-Security"][0]
  parent_id = aws_organizations_organizational_unit.closed-accounts.id

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

resource "aws_organizations_account" "moj-peoplefinder" {
  name      = "MoJ PeopleFinder"
  email     = local.aws_account_email_addresses["MoJ PeopleFinder"][0]
  parent_id = aws_organizations_organizational_unit.closed-accounts.id

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

resource "aws_organizations_account" "parliamentary-questions" {
  name      = "Parliamentary Questions"
  email     = local.aws_account_email_addresses["Parliamentary Questions"][0]
  parent_id = aws_organizations_organizational_unit.closed-accounts.id

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

resource "aws_organizations_account" "moj-intranet" {
  name      = "MOJ Intranet"
  email     = local.aws_account_email_addresses["MOJ Intranet"][0]
  parent_id = aws_organizations_organizational_unit.closed-accounts.id

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

resource "aws_organizations_account" "get-help-with-child-arrangements" {
  name      = "Get help with child arrangements"
  email     = local.aws_account_email_addresses["Get help with child arrangements"][0]
  parent_id = aws_organizations_organizational_unit.closed-accounts.id

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

resource "aws_organizations_account" "platforms-non-production" {
  name      = "platforms-non-production"
  email     = local.aws_account_email_addresses["platforms-non-production"][0]
  parent_id = aws_organizations_organizational_unit.closed-accounts.id

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

resource "aws_organizations_account" "moj-billing-management" {
  name      = "MoJ Billing Management"
  email     = local.aws_account_email_addresses["MoJ Billing Management"][0]
  parent_id = aws_organizations_organizational_unit.closed-accounts.id

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
