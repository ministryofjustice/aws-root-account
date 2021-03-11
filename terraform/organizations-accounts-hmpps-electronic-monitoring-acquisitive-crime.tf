# Electronic Monitoring Acquisitive Crime
resource "aws_organizations_account" "electronic-monitoring-acquisitive-crime-development" {
  name                       = "Electronic Monitoring Acquisitive Crime Dev"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-ac-dev")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps-electronic-monitoring-acquisitive-crime.id
  tags                       = local.tags-hmpps-em

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

resource "aws_organizations_account" "electronic-monitoring-acquisitive-crime-test" {
  name                       = "Electronic Monitoring Acquisitive Crime Test"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-ac-test")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps-electronic-monitoring-acquisitive-crime.id
  tags                       = local.tags-hmpps-em

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

resource "aws_organizations_account" "electronic-monitoring-acquisitive-crime-preproduction" {
  name                       = "Electronic Monitoring Acquisitive Crime Preprod"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-ac-preprod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps-electronic-monitoring-acquisitive-crime.id
  tags                       = local.tags-hmpps-em

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

resource "aws_organizations_account" "electronic-monitoring-acquisitive-crime-production" {
  name                       = "Electronic Monitoring Acquisitive Crime Production"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "hmpps-em-ac-prod")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.hmpps-electronic-monitoring-acquisitive-crime.id
  tags                       = local.tags-hmpps-em

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
