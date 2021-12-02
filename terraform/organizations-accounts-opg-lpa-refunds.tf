# OPG OU: LPA Refunds
resource "aws_organizations_account" "opg-refund-production" {
  name      = "opg-refund-production"
  email     = local.aws_account_email_addresses["opg-refund-production"][0]
  parent_id = aws_organizations_organizational_unit.opg-lpa-refunds.id
  tags = merge(local.tags-opg, {
    application   = "Lasting Power of Attorney Refunds/LPA Refunds"
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

resource "aws_organizations_account" "moj-opg-lpa-refunds-development" {
  name      = "MOJ OPG LPA Refunds Development"
  email     = local.aws_account_email_addresses["MOJ OPG LPA Refunds Development"][0]
  parent_id = aws_organizations_organizational_unit.opg-lpa-refunds.id
  tags = merge(local.tags-opg, {
    application = "Lasting Power of Attorney Refunds/LPA Refunds"
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

resource "aws_organizations_account" "moj-opg-lpa-refunds-preproduction" {
  name      = "MOJ OPG LPA Refunds Preproduction"
  email     = local.aws_account_email_addresses["MOJ OPG LPA Refunds Preproduction"][0]
  parent_id = aws_organizations_organizational_unit.opg-lpa-refunds.id
  tags = merge(local.tags-opg, {
    application = "Lasting Power of Attorney Refunds/LPA Refunds"
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

resource "aws_organizations_account" "moj-opg-lpa-refunds-production" {
  name      = "MOJ OPG LPA Refunds Production"
  email     = local.aws_account_email_addresses["MOJ OPG LPA Refunds Production"][0]
  parent_id = aws_organizations_organizational_unit.opg-lpa-refunds.id
  tags = merge(local.tags-opg, {
    application   = "Lasting Power of Attorney Refunds/LPA Refunds"
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
