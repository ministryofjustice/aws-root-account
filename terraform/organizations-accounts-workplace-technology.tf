# Workplace Technology OU
resource "aws_organizations_account" "workplace-tech-proof-of-concept-development" {
  name      = "Workplace Tech Proof Of Concept Development"
  email     = local.account_emails["Workplace Tech Proof Of Concept Development"][0]
  parent_id = aws_organizations_organizational_unit.workplace-technology.id

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

resource "aws_organizations_account" "wptpoc" {
  name      = "WPTPOC"
  email     = local.account_emails["WPTPOC"][0]
  parent_id = aws_organizations_organizational_unit.workplace-technology.id

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

resource "aws_organizations_account" "moj-official-production" {
  name      = "MOJ Official (Production)"
  email     = local.account_emails["MOJ Official (Production)"][0]
  parent_id = aws_organizations_organizational_unit.workplace-technology.id

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

resource "aws_organizations_account" "moj-official-pre-production" {
  name      = "MOJ Official (Pre-Production)"
  email     = local.account_emails["MOJ Official (Pre-Production)"][0]
  parent_id = aws_organizations_organizational_unit.workplace-technology.id

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

resource "aws_organizations_account" "moj-official-development" {
  name      = "MOJ Official (Development)"
  email     = local.account_emails["MOJ Official (Development)"][0]
  parent_id = aws_organizations_organizational_unit.workplace-technology.id

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
