resource "aws_organizations_account" "money_to_prisoners" {
  name                       = "Money To Prisoners"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "moneytoprisoners")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.closed_accounts.id
  tags                       = {}

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "security_logging_platform" {
  name                       = "Security Logging Platform"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "security-logging-platform")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.closed_accounts.id

  tags = local.tags_security

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "hmpps_cr_jira_non_production" {
  name                       = "HMPPS CR Jira non-production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-cr-jira-non-production")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.closed_accounts.id

  tags = merge(local.tags_community_rehabilitation, {
    application = "Community Rehabilitation - Jira"
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

# Electronic Monitoring (ProMon)
resource "aws_organizations_account" "electronic_monitoring" {
  name                       = "Electronic Monitoring"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-monitoring-mapping-test") # Repurposed account
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.closed_accounts.id

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


resource "aws_organizations_account" "cloud_platform_ephemeral_test" {
  name                       = "Cloud Platform Ephemeral Test"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "cloud-platform-ephemeral-test")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.closed_accounts.id

  tags = merge(local.tags_platforms, {
    application            = "Cloud Platform Ephemeral Test"
    environment-name       = "cloud-platform-ephemeral-test"
    owner                  = "Cloud Platform: platforms@digital.justice.gov.uk"
    infrastructure-support = "Cloud Platform: platforms@digital.justice.gov.uk"
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
