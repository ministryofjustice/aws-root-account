##############################
# GuardDuty within eu-west-1 #
##############################

# Enable GuardDuty for eu-west-1 (Ireland)
resource "aws_guardduty_detector" "eu-west-1" {
  # Set provider to eu-west-1
  provider = aws.aws-root-account-eu-west-1

  # Set enable to false if you want to suspend GuardDuty.
  # This allows you to keep historical findings rather than removing the resource
  # block, which will destroy all historical findings
  enable = true

  tags = local.root_account
}

# Delegate administratorship of GuardDuty to the organisation-security account for the eu-west-1 region
resource "aws_guardduty_organization_admin_account" "eu-west-1-administrator" {
  # Set provider to eu-west-1
  provider = aws.aws-root-account-eu-west-1

  depends_on       = [aws_organizations_organization.default]
  admin_account_id = aws_organizations_account.organisation-security.id
}

####################################
# GuardDuty detector for eu-west-1 #
####################################

# The detector is automatically created by AWS, so we need to import it before Terraform will manage it
resource "aws_guardduty_detector" "organisation-security-eu-west-1" {
  provider = aws.organisation-security-eu-west-1

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

##################################################
# GuardDuty publishing destination for eu-west-1 #
##################################################

resource "aws_guardduty_publishing_destination" "eu-west-1" {
  provider = aws.organisation-security-eu-west-1

  detector_id     = aws_guardduty_detector.organisation-security-eu-west-1.id
  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  depends_on = [
    aws_s3_bucket_policy.guardduty-bucket-policy
  ]
}

################################
# Member accounts in eu-west-1 #
################################

# Note: The local used for the for_each is defined in
# guardduty.tf

resource "aws_guardduty_member" "eu-west-1" {
  for_each = {
    for account in local.enrolled_into_guardduty :
    account.name => account.id
  }
  provider = aws.organisation-security-eu-west-1

  # We want to add these accounts as members within the Organisation Security account
  account_id  = each.value
  detector_id = aws_guardduty_detector.organisation-security-eu-west-1.id
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
