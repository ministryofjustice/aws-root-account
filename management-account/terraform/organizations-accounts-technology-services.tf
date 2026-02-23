locals {
  tags_technology_services = merge(local.tags_business_units.hq, {
    owner                  = "Technology Services Technology Operations: moj-technicaloperations@justice.gov.uk"
    infrastructure-support = "Technology Services Technology Operations: moj-technicaloperations@justice.gov.uk"
  })
}

resource "aws_organizations_account" "moj_official_development" {
  name                       = "MOJ Official (Development)"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "mojofficial-dev")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.technology_services.id
  close_on_deletion          = true

  tags = merge(local.tags_technology_services, {
    application = "MOJ Official: DHCP / DNS / Monitoring / NACs / SMTP Relay / Global Protect / Transit Gateway"
    source-code = "github.com/ministryofjustice/network-operations github.com/ministryofjustice/cloud-operations"
  })

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
  parent_id                  = aws_organizations_organizational_unit.technology_services.id
  close_on_deletion          = true

  tags = merge(local.tags_technology_services, {
    application = "MOJ Official: DHCP / DNS / Monitoring / NACs / SMTP Relay / Global Protect / Transit Gateway"
    source-code = "github.com/ministryofjustice/network-operations github.com/ministryofjustice/cloud-operations"
  })

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
  parent_id                  = aws_organizations_organizational_unit.technology_services.id
  close_on_deletion          = true

  tags = merge(local.tags_technology_services, {
    is-production = true
    application   = "MOJ Official: DHCP / DNS / Monitoring / NACs / SMTP Relay / Global Protect / Transit Gateway"
    source-code   = "github.com/ministryofjustice/network-operations github.com/ministryofjustice/cloud-operations"
  })

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
  parent_id                  = aws_organizations_organizational_unit.technology_services.id
  close_on_deletion          = true

  tags = merge(local.tags_technology_services, {
    application = "Entrust Managed VMs"
    source-code = "github.com/ministryofjustice/staff-infrastructure-certificate-services"
  })

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
  parent_id                  = aws_organizations_organizational_unit.technology_services.id
  close_on_deletion          = true

  tags = merge(local.tags_technology_services, {
    is-production = true
    application   = "Entrust Managed VMs"
    source-code   = "github.com/ministryofjustice/staff-infrastructure-certificate-services"
  })

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
  parent_id                  = aws_organizations_organizational_unit.technology_services.id
  close_on_deletion          = true

  tags = merge(local.tags_technology_services, {
    is-production = true
    application   = "Shared Services for MOJ Official - CodePipeline etc"
    source-code   = "https://github.com/ministryofjustice/staff-device-shared-services-infrastructure"
  })

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
  parent_id                  = aws_organizations_organizational_unit.technology_services.id
  close_on_deletion          = true

  tags = merge(local.tags_technology_services, {
    application = "Workplace Technology"
  })

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "network_architecture" {
  name                       = "Network Architecture"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "network-architecture")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.technology_services.id
  close_on_deletion          = true

  tags = merge(local.tags_technology_services, {
    is-production    = true
    application      = "Workplace Technology"
    environment-name = "landing-zone"
  })

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}
