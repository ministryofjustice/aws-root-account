#############
# GuardDuty #
#############

# Get the delegated administrator account ID
data "aws_caller_identity" "delegated_administrator" {
  provider = aws.delegated_administrator
}

#################################
# GuardDuty in the root account #
#################################
resource "aws_guardduty_detector" "default" {
  provider = aws.root_account

  # Set enable to false if you want to suspend GuardDuty.
  # This allows you to keep historical findings rather than removing the resource
  # block, which will destroy all historical findings
  enable = true

  tags = var.root_tags
}

####################################################
# GuardDuty in the delegated administrator account #
####################################################
resource "aws_guardduty_detector" "delegated_administrator" {
  provider = aws.delegated_administrator

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
  admin_account_id = data.aws_caller_identity.delegated_administrator.account_id

  # GuardDuty is required to be turned on in the account before you set it as the delegated administrator
  depends_on = [aws_guardduty_detector.delegated_administrator]
}
