#########
# Admin #
#########
resource "aws_iam_group" "admin" {
  name = "Admin"
  path = "/"
}

#########################
# AWSOrganisationsAdmin #
#########################
resource "aws_iam_group" "aws_organisations_admin" {
  name = "AWSOrganisationsAdmin"
  path = "/"
}

#####################
# BillingFullAccess #
#####################
resource "aws_iam_group" "billing_full_access" {
  name = "BillingFullAccess"
  path = "/"
}

#########################
# IAMUserChangePassword #
#########################
resource "aws_iam_group" "iam_user_change_password" {
  name = "IAMUserChangePassword"
  path = "/"
}

###############################################
# ModernisationPlatformOrganisationManagement #
###############################################
resource "aws_iam_group" "modernisation_platform_organisation_management" {
  name = "ModernisationPlatformOrganisationManagement"
  path = "/"
}
