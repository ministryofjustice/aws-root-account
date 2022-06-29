locals {
  tags_delius = local.tags_business_units.hmpps
}

resource "aws_organizations_account" "alfresco_non_prod" {
  name                       = "Alfresco non-prod"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "alfresco_non_prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_delius.id

  tags = merge(local.tags_delius, {

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

resource "aws_organizations_account" "delius_core_non_prod" {
  name                       = "Delius Core non-prod"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "delius_core_non_prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_delius.id

  tags = merge(local.tags_delius, {

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

resource "aws_organizations_account" "hmpps_delius_mis_non_prod" {
  name                       = "HMPPS Delius MIS non prod"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-delius-mis-non-prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_delius.id

  tags = merge(local.tags_delius, {

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

resource "aws_organizations_account" "hmpps_delius_mis_test" {
  name                       = "HMPPS Delius MIS Test"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-delius-mis-test")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_delius.id

  tags = merge(local.tags_delius, {

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

resource "aws_organizations_account" "hmpps_delius_pre_production" {
  name                       = "HMPPS Delius Pre Production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-delius-pre-prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_delius.id

  tags = merge(local.tags_delius, {

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

resource "aws_organizations_account" "hmpps_delius_stage" {
  name                       = "HMPPS Delius Stage"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-delius-stage")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_delius.id

  tags = merge(local.tags_delius, {

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

resource "aws_organizations_account" "hmpps_delius_test" {
  name                       = "HMPPS Delius Test"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-delius-test")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_delius.id

  tags = merge(local.tags_delius, {

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

resource "aws_organizations_account" "hmpps_delius_training" {
  name                       = "HMPPS Delius Training"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-delius-training")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_delius.id

  tags = merge(local.tags_delius, {

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

resource "aws_organizations_account" "probation_management_non_prod" {
  name                       = "Probation Management non-prod"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "probation_management_non_prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_delius.id

  tags = merge(local.tags_delius, {

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
