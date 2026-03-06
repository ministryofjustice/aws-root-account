locals {
  tags_cica = merge(local.tags_business_units.cica)
}

resource "aws_organizations_account" "cica_development" {
  name                       = "CICA Development"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "cica-dev")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.cica.id
  close_on_deletion          = true

  tags = merge(local.tags_cica, {
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

resource "aws_organizations_account" "cica_production" {
  name                       = "CICA Production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "cica-tnv")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.cica.id
  close_on_deletion          = true

  tags = merge(local.tags_cica, {
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

resource "aws_organizations_account" "cica_shared_services" {
  name                       = "CICA Shared Services"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "cica")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.cica.id
  close_on_deletion          = true

  tags = merge(local.tags_cica, {
    environment-name = "shared-services"
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

resource "aws_organizations_account" "cica_uat" {
  name                       = "CICA UAT"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "cica-uat")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.cica.id
  close_on_deletion          = true

  tags = merge(local.tags_cica, {
    environment-name = "user-acceptance-testing"
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
