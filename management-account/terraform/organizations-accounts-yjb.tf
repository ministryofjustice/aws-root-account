locals {
  tags_yjb = merge(local.tags_business_units.yjb, {
    application            = "Youth Justice Framework"
    owner                  = "Youth Justice Board ICT: ict@yjb.gov.uk"
    infrastructure-support = "YJAF Operations at NEC: yjafoperationsaws@necsws.com"
  })
}

resource "aws_organizations_account" "youth_justice_framework_dev" {
  name                       = "Youth Justice Framework Dev"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "youth-justice-framework-migration-dev")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.yjb.id

  tags = merge(local.tags_yjb, {
    environment-name = "development"
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

resource "aws_organizations_account" "youth_justice_framework_eng_tools" {
  name                       = "Youth Justice Framework Eng Tools"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "youth-justice-framework-migration-eng")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.yjb.id

  tags = merge(local.tags_yjb, {
    environment-name = "engineering-tools"
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

resource "aws_organizations_account" "youth_justice_framework_juniper" {
  name                       = "Youth Justice Framework Juniper"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "youth-justice-framework-migration-jun")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.yjb.id

  tags = merge(local.tags_yjb, {
    environment-name = "juniper-network"
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

resource "aws_organizations_account" "youth_justice_framework_management" {
  name                       = "Youth Justice Framework Management"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "youth-justice-framework-migration-mgt")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.yjb.id

  tags = merge(local.tags_yjb, {
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

resource "aws_organizations_account" "youth_justice_framework_monitoring" {
  name                       = "Youth Justice Framework Monitoring"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "youth-justice-framework-migration-mon")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.yjb.id

  tags = merge(local.tags_yjb, {
    environment-name = "monitoring"
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

resource "aws_organizations_account" "youth_justice_framework_pre_prod" {
  name                       = "Youth Justice Framework Pre-Prod"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "youth-justice-framework-migration-pre")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.yjb.id

  tags = merge(local.tags_yjb, {
    environment-name = "pre-production"
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

resource "aws_organizations_account" "youth_justice_framework_prod" {
  name                       = "Youth Justice Framework Prod"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "youth-justice-framework-migration-prd")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.yjb.id

  tags = merge(local.tags_yjb, {
    environment-name = "production"
    is-production    = true
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

resource "aws_organizations_account" "youth_justice_framework_sandpit" {
  name                       = "Youth Justice Framework Sandpit"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "youth-justice-framework-migration-pit")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.yjb.id

  tags = merge(local.tags_yjb, {
    environment-name = "sandpit"
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
