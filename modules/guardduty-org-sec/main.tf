#############
# GuardDuty #
#############

##################################################################
# Auto-enable GuardDuty for new accounts in the AWS Organization #
##################################################################
resource "aws_guardduty_organization_configuration" "delegated_administrator" {
  provider                         = aws.delegated_administrator
  detector_id                      = var.administrator_detector_id
  auto_enable_organization_members = var.auto_enable ? "NEW" : "NONE"
}

######################################################################
# Auto-enable S3 Logs for new accounts in the AWS Organization       #
# This replaces the deprecated `datasources` block                   #
######################################################################
resource "aws_guardduty_organization_configuration_feature" "s3_logs" {
  provider    = aws.delegated_administrator
  detector_id = var.administrator_detector_id
  name        = "S3_DATA_EVENTS"
  auto_enable = "NEW"
}

#######################################################################
# Auto-enable EKS Monitoring for new accounts in the AWS Organization #
#######################################################################
# Note we are leaving installing the security agent add-on as a manual process
resource "aws_guardduty_organization_configuration_feature" "eks_runtime_monitoring" {
  provider    = aws.delegated_administrator
  detector_id = var.administrator_detector_id
  name        = "EKS_RUNTIME_MONITORING"
  auto_enable = "NEW"

  additional_configuration {
    name        = "EKS_ADDON_MANAGEMENT"
    auto_enable = "NONE"
  }
}

####################################
# GuardDuty publishing destination #
####################################
resource "aws_guardduty_publishing_destination" "delegated_administrator" {
  provider        = aws.delegated_administrator
  detector_id     = var.administrator_detector_id
  destination_arn = var.destination_arn
  kms_key_arn     = var.kms_key_arn
}

############################
# GuardDuty ThreatIntelSet #
############################
resource "aws_guardduty_threatintelset" "default" {
  provider    = aws.delegated_administrator
  activate    = var.enable_threatintelset
  detector_id = var.administrator_detector_id
  format      = "TXT"
  location    = "https://s3.amazonaws.com/${var.threatintelset_bucket}/${var.threatintelset_key}"
  name        = var.threatintelset_key
}
