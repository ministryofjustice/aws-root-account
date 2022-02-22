locals {
  tags_workplace_technology = local.tags_business_units.hq
}

resource "aws_organizations_account" "cloud_networks_psn" {
  name                       = "Cloud Networks PSN"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "cloud_networks_PSN")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workplace_technology.id

  tags = local.tags_workplace_technology

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "moj_official_development" {
  name                       = "MOJ Official (Development)"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "mojofficial-dev")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workplace_technology.id

  tags = local.tags_workplace_technology

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "moj_official_network_operations_centre" {
  name                       = "MOJ Official (Network Operations Centre)"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "mojofficial-networkopscentre")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workplace_technology.id

  tags = local.tags_workplace_technology

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "moj_official_preproduction" {
  name                       = "MOJ Official (Pre-Production)"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "mojofficial-preprod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workplace_technology.id

  tags = local.tags_workplace_technology

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "moj_official_production" {
  name                       = "MOJ Official (Production)"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "mojofficial-prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workplace_technology.id

  tags = local.tags_workplace_technology

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "moj_official_public_key_infrastructure_dev" {
  name                       = "MOJ Official (Public Key Infrastructure Dev)"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "mojofficial-pki-dev")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workplace_technology.id

  tags = local.tags_workplace_technology

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "moj_official_public_key_infrastructure" {
  name                       = "MOJ Official (Public Key Infrastructure)"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "mojofficial-public-key-infra")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workplace_technology.id

  tags = local.tags_workplace_technology

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "moj_official_shared_services" {
  name                       = "MOJ Official (Shared Services)"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "mojofficial-shared")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workplace_technology.id

  tags = local.tags_workplace_technology

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "workplace_tech_proof_of_concept_development" {
  name                       = "Workplace Tech Proof Of Concept Development"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "wptpocdev")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workplace_technology.id

  tags = local.tags_workplace_technology

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "wptpoc" {
  name                       = "WPTPOC"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "wptpoc")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.workplace_technology.id

  tags = local.tags_workplace_technology

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}
