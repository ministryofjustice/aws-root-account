locals {
  tags-opg = merge(local.tags-business-unit.opg)
}

# OPG OU
resource "aws_organizations_account" "moj-opg-management" {
  name      = "MoJ OPG Management"
  email     = local.aws_account_email_addresses["MoJ OPG Management"][0]
  parent_id = aws_organizations_organizational_unit.opg.id
  tags = merge(local.tags-opg, {
    application = "Management"
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

resource "aws_organizations_policy_attachment" "moj-opg-management" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.moj-opg-management.id
}

resource "aws_organizations_account" "opg-shared" {
  name      = "opg-shared"
  email     = local.aws_account_email_addresses["opg-shared"][0]
  parent_id = aws_organizations_organizational_unit.opg.id
  tags = merge(local.tags-opg, {
    application = "Shared"
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

resource "aws_organizations_policy_attachment" "opg-shared" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.opg-shared.id
}

resource "aws_organizations_account" "moj-opg-shared-production" {
  name      = "MoJ OPG Shared Production"
  email     = local.aws_account_email_addresses["MoJ OPG Shared Production"][0]
  parent_id = aws_organizations_organizational_unit.opg.id
  tags = merge(local.tags-opg, {
    application   = "Shared",
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

resource "aws_organizations_policy_attachment" "moj-opg-shared-production" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.moj-opg-shared-production.id
}

resource "aws_organizations_account" "opg-backups" {
  name      = "OPG Backups"
  email     = local.aws_account_email_addresses["OPG Backups"][0]
  parent_id = aws_organizations_organizational_unit.opg.id
  tags = merge(local.tags-opg, {
    application   = "Backups",
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

resource "aws_organizations_policy_attachment" "opg-backups" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.opg-backups.id
}

resource "aws_organizations_account" "moj-opg-identity" {
  name      = "MoJ OPG Identity"
  email     = local.aws_account_email_addresses["MoJ OPG Identity"][0]
  parent_id = aws_organizations_organizational_unit.opg.id
  tags = merge(local.tags-opg, {
    application   = "Identity",
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

resource "aws_organizations_policy_attachment" "moj-opg-identity" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.moj-opg-identity.id
}

resource "aws_organizations_account" "moj-opg-shared-development" {
  name      = "MoJ OPG Shared Development"
  email     = local.aws_account_email_addresses["MoJ OPG Shared Development"][0]
  parent_id = aws_organizations_organizational_unit.opg.id
  tags = merge(local.tags-opg, {
    application = "Shared"
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

resource "aws_organizations_policy_attachment" "moj-opg-shared-development" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.moj-opg-shared-development.id
}

resource "aws_organizations_account" "moj-opg-sandbox" {
  name      = "MoJ OPG Sandbox"
  email     = local.aws_account_email_addresses["MoJ OPG Sandbox"][0]
  parent_id = aws_organizations_organizational_unit.opg.id
  tags = merge(local.tags-opg, {
    application = "Sandbox"
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

resource "aws_organizations_policy_attachment" "moj-opg-sandbox" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.moj-opg-sandbox.id
}
