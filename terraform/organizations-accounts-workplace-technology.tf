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

resource "aws_organizations_account" "moj-official-network-operations-centre" {
  name                       = "MOJ Official (Network Operations Centre)"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "mojofficial-networkopscentre")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workplace-technology.id

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

# Enrol MOJ Official Network Operations Centre to the restricted regions policy
resource "aws_organizations_policy_attachment" "moj-official-network-operations-centre-restricted-regions" {
  policy_id = aws_organizations_policy.deny-non-eu-non-us-east-1-operations.id
  target_id = aws_organizations_account.moj-official-network-operations-centre.id
}
