# OPG OU: Make an LPA
resource "aws_organizations_account" "moj-lpa-preproduction" {
  name      = "MOJ LPA Preproduction"
  email     = local.aws_account_email_addresses["MOJ LPA Preproduction"][0]
  parent_id = aws_organizations_organizational_unit.opg-make-an-lpa.id
  tags = merge(local.tags-opg, {
    application = "Make a Lasting Power of Attorney/Make an LPA"
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

resource "aws_organizations_policy_attachment" "moj-lpa-preproduction" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.moj-lpa-preproduction.id
}

resource "aws_organizations_account" "opg-lpa-production" {
  name      = "OPG LPA Production"
  email     = local.aws_account_email_addresses["OPG LPA Production"][0]
  parent_id = aws_organizations_organizational_unit.opg-make-an-lpa.id
  tags = merge(local.tags-opg, {
    application   = "Make a Lasting Power of Attorney/Make an LPA"
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

resource "aws_organizations_policy_attachment" "opg-lpa-production" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.opg-lpa-production.id
}

resource "aws_organizations_account" "moj-opg-lpa-production" {
  name      = "MOJ OPG LPA Production"
  email     = local.aws_account_email_addresses["MOJ OPG LPA Production"][0]
  parent_id = aws_organizations_organizational_unit.opg-make-an-lpa.id
  tags = merge(local.tags-opg, {
    application   = "Make a Lasting Power of Attorney/Make an LPA"
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

resource "aws_organizations_policy_attachment" "moj-opg-lpa-production" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.moj-opg-lpa-production.id
}

resource "aws_organizations_account" "moj-lpa-development" {
  name      = "MOJ LPA Development"
  email     = local.aws_account_email_addresses["MOJ LPA Development"][0]
  parent_id = aws_organizations_organizational_unit.opg-make-an-lpa.id
  tags = merge(local.tags-opg, {
    application = "Make a Lasting Power of Attorney/Make an LPA"
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

resource "aws_organizations_policy_attachment" "moj-lpa-development" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.moj-lpa-development.id
}
