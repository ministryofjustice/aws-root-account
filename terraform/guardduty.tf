# Enable GuardDuty for the default provider region, which is required to delegate a GuardDuty administrator
resource "aws_guardduty_detector" "default-region" {
  # Set enable to false if you want to suspend GuardDuty.
  # This allows you to keep historical findings rather than removing the resource
  # block, which will destroy all historical findings
  enable = true

  tags = local.root_account
}

# Delegate administratorship of GuardDuty to the organisation-security account
resource "aws_guardduty_organization_admin_account" "default-region-administrator" {
  depends_on       = [aws_organizations_organization.default]
  admin_account_id = aws_organizations_account.organisation-security.id
}

# The detector is automatically created by AWS, so we need to import it before Terraform will manage it
resource "aws_guardduty_detector" "organisation-security-eu-west-2" {
  provider = aws.organisation-security-eu-west-2

  # Set enable to false if you want to suspend GuardDuty.
  # This allows you to keep historical findings rather than removing the resource
  # block, which will destroy all historical findings
  enable = true

  # This will send GuardDuty notifications every 15 minutes, rather than every
  # 6 hours (default)
  finding_publishing_frequency = "FIFTEEN_MINUTES"

  tags = merge(
    local.tags-organisation-management, {
      component = "Security"
    }
  )
}

# Attach accounts from the AWS Organization
# This is currently done by adding accounts on a one-by-one basis as
# we need to onboard people singularly rather than all at once.
# In the future we can replace all of this with a for_each on a
# data.aws_organizations_organization.example.accounts[*].id data resource,
# and auto_enable will be turned on so new accounts won't need to be added here.
locals {
  enrolled_into_guardduty = [
    { id = local.caller_identity.account_id, name = "MoJ root account" },
    aws_organizations_account.organisation-logging,
    aws_organizations_account.moj-official-production,
    aws_organizations_account.moj-official-pre-production,
    aws_organizations_account.moj-official-development,
    aws_organizations_account.moj-official-public-key-infrastructure-dev,
    aws_organizations_account.moj-official-public-key-infrastructure,
    aws_organizations_account.moj-official-shared-services,
    aws_organizations_account.modernisation-platform
  ]
}

# eu-west-2
resource "aws_guardduty_member" "eu-west-2" {
  for_each = {
    for account in local.enrolled_into_guardduty :
    account.name => account.id
  }
  provider = aws.organisation-security-eu-west-2

  # We want to add these accounts as members within the Organisation Security account
  account_id  = each.value
  detector_id = aws_guardduty_detector.organisation-security-eu-west-2.id
  email       = "fake@email.com"
  invite      = true

  # With AWS Organizations, AWS doesn't rely on the email address provided to invite a member account,
  # as privilege is inferred by the fact that the account is already within Organizations.
  # However, once a relationship is established, the GuardDuty API returns an email address, so Terraform returns a drift.
  # Therefore, we can ignore_changes to an email address. You still need to provide one, though, so we use fake@email.com.
  lifecycle {
    ignore_changes = [
      email
    ]
  }
}
