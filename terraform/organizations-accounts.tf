# This is a slightly hacky way to get email addresses for already configured accounts.
# We should store all (including new) account email addresses in AWS Secrets Manager,
# rather than rely on this in the future.
data "aws_organizations_organization" "root" {}

locals {
  account_emails = {
    for account in data.aws_organizations_organization.root.accounts :
    account.name => account.email...
  }
}

# Accounts that sit within the root OU. This doesn't include the actual root account.
resource "aws_organizations_account" "bichard7-2020-prototype" {
  name      = "Bichard7 2020 Prototype"
  email     = local.account_emails["Bichard7 2020 Prototype"][0]
  parent_id = aws_organizations_organization.default.roots[0].id

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

resource "aws_organizations_policy_attachment" "bichard7-2020-prototype" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.bichard7-2020-prototype.id
}

resource "aws_organizations_account" "cica-development" {
  name      = "CICA Development"
  email     = local.account_emails["CICA Development"][0]
  parent_id = aws_organizations_organization.default.roots[0].id

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

resource "aws_organizations_policy_attachment" "cica-development" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.cica-development.id
}

resource "aws_organizations_account" "cica-test-verify" {
  name      = "CICA Test & Verify"
  email     = local.account_emails["CICA Test & Verify"][0]
  parent_id = aws_organizations_organization.default.roots[0].id

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

resource "aws_organizations_policy_attachment" "cica-test-verify" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.cica-test-verify.id
}

resource "aws_organizations_account" "cica-uat" {
  name      = "CICA UAT"
  email     = local.account_emails["CICA UAT"][0]
  parent_id = aws_organizations_organization.default.roots[0].id

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

resource "aws_organizations_policy_attachment" "cica-uat" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.cica-uat.id
}

resource "aws_organizations_account" "modernisation-platform" {
  name      = "Modernisation Platform"
  email     = local.account_emails["Modernisation Platform"][0]
  parent_id = aws_organizations_organization.default.roots[0].id

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

resource "aws_organizations_policy_attachment" "modernisation-platform" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.modernisation-platform.id
}

resource "aws_organizations_account" "moj-billing-management" {
  name      = "MoJ Billing Management"
  email     = local.account_emails["MoJ Billing Management"][0]
  parent_id = aws_organizations_organization.default.roots[0].id

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

resource "aws_organizations_policy_attachment" "moj-billing-management" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.moj-billing-management.id
}

resource "aws_organizations_account" "moj-official-public-key-infrastructure-dev" {
  name      = "MOJ Official (Public Key Infrastructure Dev)"
  email     = local.account_emails["MOJ Official (Public Key Infrastructure Dev)"][0]
  parent_id = aws_organizations_organization.default.roots[0].id

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

resource "aws_organizations_policy_attachment" "moj-official-public-key-infrastructure-dev" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.moj-official-public-key-infrastructure-dev.id
}

resource "aws_organizations_account" "moj-official-public-key-infrastructure" {
  name      = "MOJ Official (Public Key Infrastructure)"
  email     = local.account_emails["MOJ Official (Public Key Infrastructure)"][0]
  parent_id = aws_organizations_organization.default.roots[0].id

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

resource "aws_organizations_policy_attachment" "moj-official-public-key-infrastructure" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.moj-official-public-key-infrastructure.id
}

resource "aws_organizations_account" "moj-official-shared-services" {
  name      = "MOJ Official (Shared Services)"
  email     = local.account_emails["MOJ Official (Shared Services)"][0]
  parent_id = aws_organizations_organization.default.roots[0].id

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

resource "aws_organizations_policy_attachment" "moj-official-shared-services" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.moj-official-shared-services.id
}
