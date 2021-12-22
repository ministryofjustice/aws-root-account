#############
# GuardDuty #
#############

# Get the organization management account ID
data "aws_caller_identity" "default" {
  provider = aws.root-account
}

# Get the delegated administrator account ID
data "aws_caller_identity" "delegated-administrator" {
  provider = aws.delegated-administrator
}

#################################
# GuardDuty in the root account #
#################################
resource "aws_guardduty_detector" "default" {
  provider = aws.root-account

  # Set enable to false if you want to suspend GuardDuty.
  # This allows you to keep historical findings rather than removing the resource
  # block, which will destroy all historical findings
  enable = true

  tags = var.root_tags
}

####################################################
# GuardDuty in the delegated administrator account #
####################################################
resource "aws_guardduty_detector" "delegated-administrator" {
  provider = aws.delegated-administrator

  # Set enable to false if you want to suspend GuardDuty.
  # This allows you to keep historical findings rather than removing the resource
  # block, which will destroy all historical findings
  enable = true

  # For newly generated findings, AWS GuardDuty publishes the finding within 5 minutes, which cannot be changed.
  # For subsequent findings, you can choose to be notified again within 6 hours, 1 hour, or 15 minutes.
  # Note that member accounts inherit this setting, so it'll be set for all member accounts at the value here.
  # See: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_findings_cloudwatch.html#guardduty_findings_cloudwatch_notification_frequency
  finding_publishing_frequency = "FIFTEEN_MINUTES"

  # Enable S3 logs to be analysed in GuardDuty
  datasources {
    s3_logs {
      enable = true
    }
  }

  tags = var.administrator_tags
}

#####################################
# GuardDuty delegated administrator #
#####################################
resource "aws_guardduty_organization_admin_account" "default" {
  admin_account_id = data.aws_caller_identity.delegated-administrator.account_id

  # GuardDuty is required to be turned on in the account before you set it as the delegated administrator
  depends_on = [aws_guardduty_detector.delegated-administrator]
}

##################################################################
# Auto-enable GuardDuty for new accounts in the AWS Organization #
##################################################################
resource "aws_guardduty_organization_configuration" "delegated-administrator" {
  provider = aws.delegated-administrator

  detector_id = aws_guardduty_detector.delegated-administrator.id
  auto_enable = var.auto_enable

  # Auto-enable S3 logs to be analysed for new accounts in the AWS Organization
  datasources {
    s3_logs {
      auto_enable = true
    }
  }
}

####################################
# GuardDuty publishing destination #
####################################
resource "aws_guardduty_publishing_destination" "delegated-administrator" {
  provider = aws.delegated-administrator

  detector_id     = aws_guardduty_detector.delegated-administrator.id
  destination_arn = var.destination_arn
  kms_key_arn     = var.kms_key_arn
}

#############################
# GuardDuty member accounts #
#############################
resource "aws_guardduty_member" "delegated-administrator" {
  provider = aws.delegated-administrator

  for_each = (var.auto_enable == true && var.enrolled_into_guardduty == {}) ? {
    # You still have to enrol the organization management account into GuardDuty as it would have been created before GuardDuty is auto-enabled.
    management-account = data.aws_caller_identity.default.account_id
  } : var.enrolled_into_guardduty

  # We want to add these accounts as members within the delegated administrator account
  account_id  = each.value
  detector_id = aws_guardduty_detector.delegated-administrator.id
  email       = "placeholder-to-avoid-terraform-drift@example.com"
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

  # You need to set the GuardDuty organisation administrator before adding members
  depends_on = [aws_guardduty_organization_admin_account.default]
}

############################
# GuardDuty ThreatIntelSet #
############################
resource "aws_guardduty_threatintelset" "default" {
  provider = aws.delegated-administrator

  activate    = var.enable_threatintelset
  detector_id = aws_guardduty_detector.delegated-administrator.id
  format      = "TXT"
  location    = "https://s3.amazonaws.com/${var.threatintelset_bucket}/${var.threatintelset_key}"
  name        = var.threatintelset_key
}

#####################
# GuardDuty filters #
#####################
resource "aws_guardduty_filter" "security-operations" {
  provider = aws.delegated-administrator

  name        = "AllApartFromSecurityOperations"
  action      = "NOOP"
  detector_id = aws_guardduty_detector.delegated-administrator.id
  rank        = 1

  finding_criteria {
    criterion {
      field      = "accountId"
      not_equals = var.filterable_security_accounts
    }
  }
}
