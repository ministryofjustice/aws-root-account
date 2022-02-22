locals {
  tags_electronic_monitoring = local.tags_business_units.hmpps
}

# Electronic Monitoring Archive & Query Service
resource "aws_organizations_account" "electronic_monitoring_archive_and_query_service" {
  name                       = "Electronic Monitoring Archive & Query Service"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-archive-query")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_electronic_monitoring.id

  tags = merge(local.tags_electronic_monitoring, {

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

# Electronic Monitoring Identity & Access Management
resource "aws_organizations_account" "electronic_monitoring_identity_and_access_management" {
  name                       = "Electronic Monitoring Identity & Access Management"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-idam")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_electronic_monitoring.id

  tags = merge(local.tags_electronic_monitoring, {

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

# Electronic Monitoring Infrastructure Dev
resource "aws_organizations_account" "electronic_monitoring_infrastructure_dev" {
  name                       = "Electronic Monitoring Infrastructure Dev"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-infra-dev")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_electronic_monitoring.id

  tags = merge(local.tags_electronic_monitoring, {

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

# Electronic Monitoring Monitoring&Mapping Dev
resource "aws_organizations_account" "electronic_monitoring_monitoring_and_mapping_dev" {
  name                       = "Electronic Monitoring Monitoring&Mapping Dev"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-monitoring-mapping-dev")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_electronic_monitoring.id

  tags = merge(local.tags_electronic_monitoring, {

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

# Electronic Monitoring Monitoring&Mapping Pre-Prod
resource "aws_organizations_account" "electronic_monitoring_monitoring_and_mapping_pre_prod" {
  name                       = "Electronic Monitoring Monitoring&Mapping Pre-Prod"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-monitoring-mapping-pre-prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_electronic_monitoring.id

  tags = merge(local.tags_electronic_monitoring, {

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

# Electronic Monitoring Monitoring&Mapping Prod
resource "aws_organizations_account" "electronic_monitoring_monitoring_and_mapping_prod" {
  name                       = "Electronic Monitoring Monitoring&Mapping Prod"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-monitoring-mapping-prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_electronic_monitoring.id

  tags = merge(local.tags_electronic_monitoring, {

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

# Electronic Monitoring Monitoring&Mapping Test
resource "aws_organizations_account" "electronic_monitoring_monitoring_and_mapping_test" {
  name                       = "Electronic Monitoring Monitoring&Mapping Test"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-monitoring-mapping-test")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_electronic_monitoring.id

  tags = merge(local.tags_electronic_monitoring, {

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

# Electronic Monitoring Protective Monitoring
resource "aws_organizations_account" "electronic_monitoring_protective_monitoring" {
  name                       = "Electronic Monitoring Protective Monitoring"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-promon")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_electronic_monitoring.id

  tags = merge(local.tags_electronic_monitoring, {

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

# Electronic Monitoring Shared Logging
resource "aws_organizations_account" "electronic_monitoring_shared_logging" {
  name                       = "Electronic Monitoring Shared Logging"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-shared-logging")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_electronic_monitoring.id

  tags = merge(local.tags_electronic_monitoring, {

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

# Electronic Monitoring Shared Networking
resource "aws_organizations_account" "electronic_monitoring_shared_networking" {
  name                       = "Electronic Monitoring Shared Networking"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-shared-networking")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_electronic_monitoring.id

  tags = merge(local.tags_electronic_monitoring, {

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

# Electronic Monitoring Shared Networking (non-prod)
resource "aws_organizations_account" "electronic_monitoring_shared_networking_non_prod" {
  name                       = "Electronic Monitoring Shared Networking (non-prod)"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-shared-networking-nonprod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_electronic_monitoring.id

  tags = merge(local.tags_electronic_monitoring, {

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

# Electronic Monitoring Tagging Hardware Pre-Prod
resource "aws_organizations_account" "electronic_monitoring_tagging_hardware_pre_prod" {
  name                       = "Electronic Monitoring Tagging Hardware Pre-Prod"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-tagging-hardware-pre-prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_electronic_monitoring.id

  tags = merge(local.tags_electronic_monitoring, {

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

# Electronic Monitoring Tagging Hardware Prod
resource "aws_organizations_account" "electronic_monitoring_tagging_hardware_prod" {
  name                       = "Electronic Monitoring Tagging Hardware Prod"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-tagging-hardware-prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_electronic_monitoring.id

  tags = merge(local.tags_electronic_monitoring, {

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

# Electronic Monitoring Tagging Hardware Test
resource "aws_organizations_account" "electronic_monitoring_tagging_hardware_test" {
  name                       = "Electronic Monitoring Tagging Hardware Test"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-tagging-hardware-test")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_electronic_monitoring.id

  tags = merge(local.tags_electronic_monitoring, {

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

