locals {
  tags_electronic_monitoring_acquisitive_crime = local.tags_business_units.hmpps
}

resource "aws_organizations_account" "electronic_monitoring_acquisitive_crime_dev" {
  name                       = "Electronic Monitoring Acquisitive Crime Dev"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-ac-dev")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_electronic_monitoring_acquisitive_crime.id

  tags = merge(local.tags_electronic_monitoring_acquisitive_crime, {

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

resource "aws_organizations_account" "electronic_monitoring_acquisitive_crime_preprod" {
  name                       = "Electronic Monitoring Acquisitive Crime Preprod"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-ac-preprod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_electronic_monitoring_acquisitive_crime.id

  tags = merge(local.tags_electronic_monitoring_acquisitive_crime, {

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

resource "aws_organizations_account" "electronic_monitoring_acquisitive_crime_production" {
  name                       = "Electronic Monitoring Acquisitive Crime Production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-ac-prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_electronic_monitoring_acquisitive_crime.id

  tags = merge(local.tags_electronic_monitoring_acquisitive_crime, {

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

resource "aws_organizations_account" "electronic_monitoring_acquisitive_crime_test" {
  name                       = "Electronic Monitoring Acquisitive Crime Test"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-ac-test")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_electronic_monitoring_acquisitive_crime.id

  tags = merge(local.tags_electronic_monitoring_acquisitive_crime, {

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
