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
# This is currently done one-by-one as we need to onboard people singularly rather than all at once.
# In the future we can replace all of this with a for_each

# MOJ root account
resource "aws_guardduty_member" "root-account" {
  provider = aws.organisation-security-eu-west-2

  # We want to add this account as a member within the Organisation Security account
  account_id  = local.caller_identity.account_id
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

# organisation-logging account
resource "aws_guardduty_member" "organisation-logging" {
  provider = aws.organisation-security-eu-west-2

  # We want to add this account as a member within the Organisation Security account
  account_id  = aws_organizations_account.organisation-logging.id
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

# MOJ Official accounts
resource "aws_guardduty_member" "moj-official-production" {
  provider = aws.organisation-security-eu-west-2

  # We want to add this account as a member within the Organisation Security account
  account_id  = aws_organizations_account.moj-official-production.id
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

resource "aws_guardduty_member" "moj-official-pre-production" {
  provider = aws.organisation-security-eu-west-2

  # We want to add this account as a member within the Organisation Security account
  account_id  = aws_organizations_account.moj-official-pre-production.id
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

resource "aws_guardduty_member" "moj-official-development" {
  provider = aws.organisation-security-eu-west-2

  # We want to add this account as a member within the Organisation Security account
  account_id  = aws_organizations_account.moj-official-development.id
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

resource "aws_guardduty_member" "moj-official-public-key-infrastructure-dev" {
  provider = aws.organisation-security-eu-west-2

  # We want to add this account as a member within the Organisation Security account
  account_id  = aws_organizations_account.moj-official-public-key-infrastructure-dev.id
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

resource "aws_guardduty_member" "moj-official-public-key-infrastructure" {
  provider = aws.organisation-security-eu-west-2

  # We want to add this account as a member within the Organisation Security account
  account_id  = aws_organizations_account.moj-official-public-key-infrastructure.id
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

resource "aws_guardduty_member" "moj-official-shared-services" {
  provider = aws.organisation-security-eu-west-2

  # We want to add this account as a member within the Organisation Security account
  account_id  = aws_organizations_account.moj-official-shared-services.id
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
