# OPG OU: Make an LPA
resource "aws_organizations_account" "moj-lpa-preproduction" {
  name      = "MOJ LPA Preproduction"
  email     = local.account_emails["MOJ LPA Preproduction"][0]
  parent_id = aws_organizations_organizational_unit.opg-make-an-lpa.id

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

resource "aws_organizations_account" "opg-lpa-production" {
  name      = "OPG LPA Production"
  email     = local.account_emails["OPG LPA Production"][0]
  parent_id = aws_organizations_organizational_unit.opg-make-an-lpa.id

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

resource "aws_organizations_account" "moj-opg-lpa-production" {
  name      = "MOJ OPG LPA Production"
  email     = local.account_emails["MOJ OPG LPA Production"][0]
  parent_id = aws_organizations_organizational_unit.opg-make-an-lpa.id

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

resource "aws_organizations_account" "moj-lpa-development" {
  name      = "MOJ LPA Development"
  email     = local.account_emails["MOJ LPA Development"][0]
  parent_id = aws_organizations_organizational_unit.opg-make-an-lpa.id

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
