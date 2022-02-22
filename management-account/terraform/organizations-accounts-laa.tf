locals {
  tags_laa = local.tags_business_units.laa
}

resource "aws_organizations_account" "laa_cloudtrail" {
  name                       = "LAA CloudTrail"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "LAA+CloudTrail")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.laa.id

  tags = local.tags_laa

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "laa_development" {
  name                       = "LAA Development"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "LAA+Development")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.laa.id

  tags = local.tags_laa

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "laa_production" {
  name                       = "LAA Production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "LAA+Production")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.laa.id

  tags = local.tags_laa

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "laa_shared_services" {
  name                       = "LAA Shared services"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "LAA+Shared+services")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.laa.id

  tags = local.tags_laa

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "laa_staging" {
  name                       = "LAA Staging"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "laa+staging")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.laa.id

  tags = local.tags_laa

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "laa_test" {
  name                       = "LAA Test"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "LAA+Test")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.laa.id

  tags = local.tags_laa

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "laa_uat" {
  name                       = "LAA UAT"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "laa-uat")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.laa.id

  tags = local.tags_laa

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "legal_aid_agency" {
  name                       = "Legal Aid Agency"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "legalaid")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.laa.id

  tags = local.tags_laa

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}
