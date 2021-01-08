# AdministratorAccess
resource "aws_ssoadmin_permission_set" "administrator-access" {
  name             = "AdministratorAccess"
  instance_arn     = local.sso_instance_arn
  session_duration = "PT1H"
}

# ViewOnlyAccess
resource "aws_ssoadmin_permission_set" "view-only-access" {
  name             = "ViewOnlyAccess"
  instance_arn     = local.sso_instance_arn
  session_duration = "PT1H"
}

# SecurityAudit
resource "aws_ssoadmin_permission_set" "security-audit" {
  name             = "SecurityAudit"
  instance_arn     = local.sso_instance_arn
  session_duration = "PT1H"
}

# AWSSSOReadOnly
resource "aws_ssoadmin_permission_set" "aws-sso-readonly" {
  name             = "AWSSSOReadOnly"
  description      = "Read-only access to AWS SSO"
  instance_arn     = local.sso_instance_arn
  session_duration = "PT1H"
}

# DashboardAccess
resource "aws_ssoadmin_permission_set" "dashboard-access" {
  name             = "DashboardAccess"
  instance_arn     = local.sso_instance_arn
  session_duration = "PT1H"
}

################################
# OPG specific permission sets #
################################

# opg-security-audit
resource "aws_ssoadmin_permission_set" "opg-security-audit" {
  name             = "opg-security-audit"
  description      = "Allow SecOps access into OPG accounts"
  instance_arn     = local.sso_instance_arn
  session_duration = "PT1H"
}

# opg-viewer
resource "aws_ssoadmin_permission_set" "opg-viewer" {
  name             = "opg-viewer"
  description      = "Standard viewer role given to all members of OPG Digital"
  instance_arn     = local.sso_instance_arn
  session_duration = "PT1H"
}

# opg-breakglass
resource "aws_ssoadmin_permission_set" "opg-breakglass" {
  name             = "opg-breakglass"
  description      = "Breakglass role given to the webops engineers at OPG incase of emergencies"
  instance_arn     = local.sso_instance_arn
  session_duration = "PT1H"
}
