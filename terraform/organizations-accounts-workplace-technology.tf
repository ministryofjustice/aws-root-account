# AWS accounts for Workplace Technology and MoJ Official
locals {
  tags-workplace-technology = {
    business-unit = "HQ"
  }
}

# Workplace Technology OU
resource "aws_organizations_account" "workplace-tech-proof-of-concept-development" {
  name      = "Workplace Tech Proof Of Concept Development"
  email     = local.aws_account_email_addresses["Workplace Tech Proof Of Concept Development"][0]
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

  tags = local.tags-workplace-technology
}

resource "aws_organizations_policy_attachment" "workplace-tech-proof-of-concept-development" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.workplace-tech-proof-of-concept-development.id
}

resource "aws_organizations_account" "wptpoc" {
  name      = "WPTPOC"
  email     = local.aws_account_email_addresses["WPTPOC"][0]
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

  tags = local.tags-workplace-technology
}

resource "aws_organizations_policy_attachment" "wptpoc" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.wptpoc.id
}

resource "aws_organizations_account" "moj-official-production" {
  name      = "MOJ Official (Production)"
  email     = local.aws_account_email_addresses["MOJ Official (Production)"][0]
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

  tags = local.tags-workplace-technology
}

resource "aws_organizations_policy_attachment" "moj-official-production" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.moj-official-production.id
}

resource "aws_organizations_account" "moj-official-pre-production" {
  name      = "MOJ Official (Pre-Production)"
  email     = local.aws_account_email_addresses["MOJ Official (Pre-Production)"][0]
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

  tags = local.tags-workplace-technology
}

resource "aws_organizations_policy_attachment" "moj-official-pre-production" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.moj-official-pre-production.id
}

resource "aws_organizations_account" "moj-official-development" {
  name      = "MOJ Official (Development)"
  email     = local.aws_account_email_addresses["MOJ Official (Development)"][0]
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

  tags = local.tags-workplace-technology
}

resource "aws_organizations_policy_attachment" "moj-official-development" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.moj-official-development.id
}

resource "aws_organizations_account" "moj-official-public-key-infrastructure-dev" {
  name      = "MOJ Official (Public Key Infrastructure Dev)"
  email     = local.aws_account_email_addresses["MOJ Official (Public Key Infrastructure Dev)"][0]
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

  tags = local.tags-workplace-technology
}

resource "aws_organizations_policy_attachment" "moj-official-public-key-infrastructure-dev" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.moj-official-public-key-infrastructure-dev.id
}

resource "aws_organizations_account" "moj-official-public-key-infrastructure" {
  name      = "MOJ Official (Public Key Infrastructure)"
  email     = local.aws_account_email_addresses["MOJ Official (Public Key Infrastructure)"][0]
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

  tags = local.tags-workplace-technology
}

resource "aws_organizations_policy_attachment" "moj-official-public-key-infrastructure" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.moj-official-public-key-infrastructure.id
}

resource "aws_organizations_account" "moj-official-shared-services" {
  name      = "MOJ Official (Shared Services)"
  email     = local.aws_account_email_addresses["MOJ Official (Shared Services)"][0]
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

  tags = local.tags-workplace-technology
}

resource "aws_organizations_policy_attachment" "moj-official-shared-services" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.moj-official-shared-services.id
}
