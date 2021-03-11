# OPG OU: Sirius
resource "aws_organizations_account" "moj-opg-sirius-production" {
  name      = "MoJ OPG Sirius Production"
  email     = local.aws_account_email_addresses["MoJ OPG Sirius Production"][0]
  parent_id = aws_organizations_organizational_unit.opg-sirius.id
  tags = merge(local.tags-opg, {
    application   = "Sirius",
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

resource "aws_organizations_account" "moj-opg-sirius-development" {
  name      = "MoJ OPG Sirius Development"
  email     = local.aws_account_email_addresses["MoJ OPG Sirius Development"][0]
  parent_id = aws_organizations_organizational_unit.opg-sirius.id
  tags = merge(local.tags-opg, {
    application = "Sirius"
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

resource "aws_organizations_account" "opg-sirius-dev" {
  name      = "opg-sirius-dev"
  email     = local.aws_account_email_addresses["opg-sirius-dev"][0]
  parent_id = aws_organizations_organizational_unit.opg-sirius.id
  tags = merge(local.tags-opg, {
    application = "Sirius"
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

resource "aws_organizations_account" "moj-opg-sirius-preproduction" {
  name      = "MoJ OPG Sirius Preproduction"
  email     = local.aws_account_email_addresses["MoJ OPG Sirius Preproduction"][0]
  parent_id = aws_organizations_organizational_unit.opg-sirius.id
  tags = merge(local.tags-opg, {
    application = "Sirius"
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

resource "aws_organizations_account" "opg-sirius-backup" {
  name      = "OPG Sirius Backup"
  email     = local.aws_account_email_addresses["OPG Sirius Backup"][0]
  parent_id = aws_organizations_organizational_unit.opg-sirius.id
  tags = merge(local.tags-opg, {
    application   = "Sirius Backups"
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

resource "aws_organizations_account" "opg-sirius-production" {
  name      = "OPG Sirius Production"
  email     = local.aws_account_email_addresses["OPG Sirius Production"][0]
  parent_id = aws_organizations_organizational_unit.opg-sirius.id
  tags = merge(local.tags-opg, {
    application   = "Sirius"
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
