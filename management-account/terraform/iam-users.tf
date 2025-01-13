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

#################
# Ewa Stempel #
#################
resource "aws_iam_user" "ewa_stempel" {
  name          = "EwaStempel"
  path          = "/"
  force_destroy = true
  tags          = {}
}

# User membership
resource "aws_iam_user_group_membership" "ewa_stempel" {
  user = aws_iam_user.ewa_stempel.name

  groups = [
    aws_iam_group.iam_user_change_password.name,
    aws_iam_group.modernisation_platform_organisation_management.name,
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

##############
# Ona Ojukwu #
##############
resource "aws_iam_user" "ona_ojukwu" {
  name          = "OnaOjukwu"
  path          = "/"
  force_destroy = true
  tags          = {}
}

# User membership
resource "aws_iam_user_group_membership" "ona_ojukwu" {
  user = aws_iam_user.ona_ojukwu.name

  groups = [
    aws_iam_group.billing_full_access.name,
    aws_iam_group.iam_user_change_password.name,
  ]
}


################
# Finance team #
################

variable "finance_team" {
  description = "Finance team members"
  type        = list(string)
  default = [
    # Finance business partners
    "NickiStowe",
    "CherylJackson",

    # Digital finance team
    "TraceyCampbell",
    "DavidCooper",
    "MarkAstley",
    "AkaashRameshan",

    # Accounting
    "ColinMcDonald",
  ]
}

resource "aws_iam_user" "finance_team" {
  for_each      = toset(var.finance_team)
  name          = each.value
  path          = "/"
  force_destroy = true
  tags          = {}
}

# User membership
resource "aws_iam_user_group_membership" "finance_team" {
  for_each = toset(var.finance_team)
  user     = aws_iam_user.finance_team[each.key].name

  groups = [
    aws_iam_group.billing_full_access.name,
    aws_iam_group.iam_user_change_password.name,
  ]
}

#####################
# Cortex XSOAR user #
#####################

resource "aws_iam_user" "xsoar_integration" {
  name          = "XsoarIntegration"
  path          = "/"
  force_destroy = true
  tags          = {}
}

# User membership
resource "aws_iam_user_group_membership" "xsoar_integration" {
  user = aws_iam_user.xsoar_integration.name

  groups = [
    aws_iam_group.aws_organisations_listreadonly.name,
  ]
}

