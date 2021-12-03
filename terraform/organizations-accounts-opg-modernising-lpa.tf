# OPG OU: Modernising LPA
resource "aws_organizations_account" "opg-modernising-lpa-development" {
  name = "OPG Modernising LPA Development"
  # This account is repurposed from MoJ OPG Sirius Development
  email     = local.aws_account_email_addresses["MoJ OPG Sirius Development"][0]
  parent_id = aws_organizations_organizational_unit.opg-modernising-lpa.id
  tags = merge(local.tags-opg, {
    application = "Modernising LPA"
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

resource "aws_organizations_account" "opg-modernising-lpa-preproduction" {
  name = "OPG Modernising LPA PreProduction"
  # This account is repurposed from opg-refund-develop
  email     = local.aws_account_email_addresses["opg-refund-develop"][0]
  parent_id = aws_organizations_organizational_unit.opg-modernising-lpa.id
  tags = merge(local.tags-opg, {
    application = "Modernising LPA"
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

resource "aws_organizations_account" "opg-modernising-lpa-production" {
  name = "OPG Modernising LPA Production"
  # This account is repurposed from MoJ OPG Sirius Production
  email     = local.aws_account_email_addresses["MoJ OPG Sirius Production"][0]
  parent_id = aws_organizations_organizational_unit.opg-modernising-lpa.id
  tags = merge(local.tags-opg, {
    application   = "Modernising LPA",
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
