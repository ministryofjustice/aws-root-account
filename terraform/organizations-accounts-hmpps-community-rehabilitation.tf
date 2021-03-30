locals {
  tags-hmpps-community-rehabilitation = merge(local.tags-business-unit.hmpps, {
    owner = ""
  })
  tags-hmpps-community-rehabilitation-jitbit = merge(local.tags-hmpps-community-rehabilitation, {
    application      = "Community Rehabilitation - Jitbit"
    environment-name = "non-production"
  })
  tags-hmpps-community-rehabilitation-jira = merge(local.tags-hmpps-community-rehabilitation, {
    application      = "Community Rehabilitation - Jira"
    environment-name = "non-production"
  })
  tags-hmpps-community-rehabilitation-unpaid-work = merge(local.tags-hmpps-community-rehabilitation, {
    application      = "Community Rehabilitation - Unpaid Work"
    environment-name = "non-production"
  })
}

# Jitbit (software)
resource "aws_organizations_account" "hmpps-community-rehabilitation-jitbit-non-production" {
  name                       = "HMPPS CR Jitbit non-production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-cr-jitbit-non-production")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps-community-rehabilitation.id

  tags = merge(local.tags-hmpps-community-rehabilitation-jitbit)

  lifecycle {
    # If any of these attributes are changed, it attempts to destroy and recreate the account,
    # so we should ignore the changes to prevent this from happening.
    ignore_changes = [
      name,
      email,
      iam_user_access_to_billing,
      role_name
    ]
  }
}

resource "aws_organizations_account" "hmpps-community-rehabilitation-jitbit-production" {
  name                       = "HMPPS CR Jitbit production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-cr-jitbit-production")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps-community-rehabilitation.id

  tags = merge(local.tags-hmpps-community-rehabilitation-jitbit, {
    is-production    = true
    environment-name = "production"
  })

  lifecycle {
    # If any of these attributes are changed, it attempts to destroy and recreate the account,
    # so we should ignore the changes to prevent this from happening.
    ignore_changes = [
      name,
      email,
      iam_user_access_to_billing,
      role_name
    ]
  }
}

# Jira Service Desk (software)
resource "aws_organizations_account" "hmpps-community-rehabilitation-jira-non-production" {
  name                       = "HMPPS CR Jira non-production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-cr-jira-non-production")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps-community-rehabilitation.id

  tags = merge(local.tags-hmpps-community-rehabilitation-jira)

  lifecycle {
    # If any of these attributes are changed, it attempts to destroy and recreate the account,
    # so we should ignore the changes to prevent this from happening.
    ignore_changes = [
      name,
      email,
      iam_user_access_to_billing,
      role_name
    ]
  }
}

resource "aws_organizations_account" "hmpps-community-rehabilitation-jira-production" {
  name                       = "HMPPS CR Jira production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-cr-jira-production")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps-community-rehabilitation.id

  tags = merge(local.tags-hmpps-community-rehabilitation-jira, {
    is-production    = true
    environment-name = "production"
  })

  lifecycle {
    # If any of these attributes are changed, it attempts to destroy and recreate the account,
    # so we should ignore the changes to prevent this from happening.
    ignore_changes = [
      name,
      email,
      iam_user_access_to_billing,
      role_name
    ]
  }
}

# Unpaid Work (CP Oracle) (supporting service)
resource "aws_organizations_account" "hmpps-community-rehabilitation-unpaid-work-non-production" {
  name                       = "HMPPS CR Unpaid Work non-production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-cr-unpaid-work-non-production")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps-community-rehabilitation.id

  tags = merge(local.tags-hmpps-community-rehabilitation-unpaid-work)

  lifecycle {
    # If any of these attributes are changed, it attempts to destroy and recreate the account,
    # so we should ignore the changes to prevent this from happening.
    ignore_changes = [
      name,
      email,
      iam_user_access_to_billing,
      role_name
    ]
  }
}

resource "aws_organizations_account" "hmpps-community-rehabilitation-unpaid-work-production" {
  name                       = "HMPPS CR Unpaid Work production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-cr-unpaid-work-production")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps-community-rehabilitation.id

  tags = merge(local.tags-hmpps-community-rehabilitation-unpaid-work, {
    is-production    = true
    environment-name = "production"
  })

  lifecycle {
    # If any of these attributes are changed, it attempts to destroy and recreate the account,
    # so we should ignore the changes to prevent this from happening.
    ignore_changes = [
      name,
      email,
      iam_user_access_to_billing,
      role_name
    ]
  }
}
