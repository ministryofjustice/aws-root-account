#################################
# Security Hub within eu-west-2 #
#################################

locals {
  enrolled_into_securityhub = concat([
    { id = local.caller_identity.account_id, name = "MoJ root account" },
    aws_organizations_account.modernisation-platform,
  ], local.modernisation-platform-managed-account-ids)
}

# Enable Security Hub for the default provider region, which is required to delegate a Security Hub administrator
module "securityhub-default-region" {
  source = "./modules/securityhub"
}

# Enable SecurityHub in the organisation-security account, which is required to become a delegated administrator
module "securityhub-organisation-security-eu-west-2" {
  providers = {
    aws = aws.organisation-security-eu-west-2
  }

  source = "./modules/securityhub"
}

# Delegate administratorship of Security Hub to organisation-security
resource "aws_securityhub_organization_admin_account" "default-region-administrator" {
  depends_on = [
    aws_organizations_organization.default,
    module.securityhub-organisation-security-eu-west-2
  ]
  admin_account_id = aws_organizations_account.organisation-security.id
}

################################
# Member accounts in eu-west-2 #
################################

resource "aws_securityhub_member" "eu-west-2" {
  # Note that this resource returns an UnprocessedAccount error when a member is removed, so you need to login to the AWS console
  # and do it manually, however, no one should be removed once enrolled.
  # See: https://docs.aws.amazon.com/guardduty/latest/APIReference/API_UnprocessedAccount.html
  for_each = {
    for account in local.enrolled_into_securityhub :
    account.name => account.id
  }
  provider = aws.organisation-security-eu-west-2

  # We want to add these accounts as members within the Organisation Security account
  account_id = each.value
  email      = "placeholder-to-avoid-terraform-drift@example.com"
  invite     = false

  depends_on = [aws_securityhub_organization_admin_account.default-region-administrator]

  # With AWS Organizations, AWS doesn't rely on the email address provided and doesn't send an invite to a member account,
  # as privilege is inferred by the fact the account is already within Organiations.
  # However, once a relationship is established, the SecurityHub API returns an email address, and sets `invite` to true,
  # so Terraform returns a drift.
  # Therefore, we can ignore_changes on both `email` and `invite`. You still need to provide an email, though, so we use
  # placeholder-to-avoid-terraform-drift@example.com as it's a reserved domain (see: https://www.iana.org/domains/reserved)
  lifecycle {
    ignore_changes = [
      email,
      invite
    ]
  }
}
