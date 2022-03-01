##################
# Anthony Bishop #
##################
resource "aws_iam_user" "anthony_bishop" {
  name          = "AnthonyBishop"
  path          = "/"
  force_destroy = true
  tags          = {}
}

# User membership
resource "aws_iam_user_group_membership" "anthony_bishop" {
  user = aws_iam_user.anthony_bishop.name

  groups = [
    aws_iam_group.aws_organisations_admin.name,
    aws_iam_group.billing_full_access.name,
    aws_iam_group.iam_user_change_password.name,
  ]
}

#################
# David Elliott #
#################
resource "aws_iam_user" "david_elliott" {
  name          = "DavidElliott"
  path          = "/"
  force_destroy = true
  tags          = {}
}

# User membership
resource "aws_iam_user_group_membership" "david_elliott" {
  user = aws_iam_user.david_elliott.name

  groups = [
    aws_iam_group.iam_user_change_password.name,
    aws_iam_group.modernisation_platform_organisation_management.name,
  ]
}

###############
# Jake Mulley #
###############
resource "aws_iam_user" "jake_mulley" {
  name          = "JakeMulley"
  path          = "/"
  force_destroy = true
  tags          = {}
}

# User membership
resource "aws_iam_user_group_membership" "jake_mulley" {
  user = aws_iam_user.jake_mulley.name

  groups = [
    aws_iam_group.admin.name,
    aws_iam_group.billing_full_access.name,
    aws_iam_group.iam_user_change_password.name,
  ]
}

##################
# Jason Birchall #
##################
resource "aws_iam_user" "jason_birchall" {
  name          = "JasonBirchall"
  path          = "/"
  force_destroy = true
  tags          = {}
}

# User membership
resource "aws_iam_user_group_membership" "jason_birchall" {
  user = aws_iam_user.jason_birchall.name

  groups = [
    aws_iam_group.admin.name,
    aws_iam_group.aws_organisations_admin.name,
    aws_iam_group.iam_user_change_password.name,
  ]
}

###############################################
# ModernisationPlatformOrganisationManagement #
###############################################
resource "aws_iam_user" "modernisation_platform_organisation_management" {
  name          = "ModernisationPlatformOrganisationManagement"
  path          = "/"
  force_destroy = true
  tags          = {}
}

# User membership
resource "aws_iam_user_group_membership" "modernisation_platform_organisation_management" {
  user = aws_iam_user.modernisation_platform_organisation_management.name

  groups = [
    aws_iam_group.modernisation_platform_organisation_management.name
  ]
}

###############
# Paul Wyborn #
###############
resource "aws_iam_user" "paul_wyborn" {
  name          = "PaulWyborn"
  path          = "/"
  force_destroy = true
  tags          = {}
}

# User membership
resource "aws_iam_user_group_membership" "paul_wyborn" {
  user = aws_iam_user.paul_wyborn.name

  groups = [
    aws_iam_group.admin.name,
    aws_iam_group.aws_organisations_admin.name,
    aws_iam_group.billing_full_access.name,
    aws_iam_group.iam_user_change_password.name,
  ]
}

########################
# Poornima Krishnasamy #
########################
resource "aws_iam_user" "poornima_krishnasamy" {
  name          = "Poornima.Krishnasamy"
  path          = "/"
  force_destroy = true
  tags          = {}
}

# User membership
resource "aws_iam_user_group_membership" "poornima_krishnasamy" {
  user = aws_iam_user.poornima_krishnasamy.name

  groups = [
    aws_iam_group.admin.name,
    aws_iam_group.aws_organisations_admin.name,
    aws_iam_group.billing_full_access.name,
  ]
}

##############
# Sablu Miah #
##############
resource "aws_iam_user" "sablu_miah" {
  name          = "SabluMiah"
  path          = "/"
  force_destroy = true
  tags          = {}
}

# User membership
resource "aws_iam_user_group_membership" "sablu_miah" {
  user = aws_iam_user.sablu_miah.name

  groups = [
    aws_iam_group.admin.name,
    aws_iam_group.aws_organisations_admin.name,
    aws_iam_group.iam_user_change_password.name,
  ]
}

##################
# Steve Marshall #
##################
resource "aws_iam_user" "steve_marshall" {
  name          = "SteveMarshall"
  path          = "/"
  force_destroy = true
  tags          = {}
}

# User membership
resource "aws_iam_user_group_membership" "steve_marshall" {
  user = aws_iam_user.steve_marshall.name

  groups = [
    aws_iam_group.admin.name,
    aws_iam_group.aws_organisations_admin.name,
    aws_iam_group.billing_full_access.name,
    aws_iam_group.iam_user_change_password.name,
  ]
}
