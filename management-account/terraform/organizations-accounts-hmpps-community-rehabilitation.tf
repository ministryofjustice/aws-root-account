locals {
  tags_community_rehabilitation = local.tags_business_units.hmpps
}

resource "aws_organizations_account" "hmpps_cr_jira_non_production" {
  name                       = "HMPPS CR Jira non-production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-cr-jira-non-production")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_community_rehabilitation.id

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

resource "aws_organizations_account" "hmpps_cr_jira_production" {
  name                       = "HMPPS CR Jira production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-cr-jira-production")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_community_rehabilitation.id

  tags = merge(local.tags_community_rehabilitation, {
    application   = "Community Rehabilitation - Jira"
    is-production = true
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

resource "aws_organizations_account" "hmpps_cr_jitbit_non_production" {
  name                       = "HMPPS CR Jitbit non-production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-cr-jitbit-non-production")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_community_rehabilitation.id

  tags = merge(local.tags_community_rehabilitation, {
    application = "Community Rehabilitation - Jitbit"
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

resource "aws_organizations_account" "hmpps_cr_jitbit_production" {
  name                       = "HMPPS CR Jitbit production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-cr-jitbit-production")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_community_rehabilitation.id

  tags = merge(local.tags_community_rehabilitation, {
    application   = "Community Rehabilitation - Jitbit"
    is-production = true
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

resource "aws_organizations_account" "hmpps_cr_unpaid_work_non_production" {
  name                       = "HMPPS CR Unpaid Work non-production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-cr-unpaid-work-non-production")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_community_rehabilitation.id

  tags = merge(local.tags_community_rehabilitation, {
    application = "Community Rehabilitation - Unpaid Work"
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

resource "aws_organizations_account" "hmpps_cr_unpaid_work_production" {
  name                       = "HMPPS CR Unpaid Work production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-cr-unpaid-work-production")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps_community_rehabilitation.id

  tags = merge(local.tags_community_rehabilitation, {
    application   = "Community Rehabilitation - Unpaid Work"
    is-production = true
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

