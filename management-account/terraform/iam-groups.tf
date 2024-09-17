#########
# Admin #
#########
resource "aws_iam_group" "admin" {
  name = "Admin"
  path = "/"
}

# Group policy attachments
resource "aws_iam_group_policy_attachment" "admin" {
  group      = aws_iam_group.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

#########################
# AWSOrganisationsAdmin #
#########################
resource "aws_iam_group" "aws_organisations_admin" {
  name = "AWSOrganisationsAdmin"
  path = "/"
}

# Group policy attachments
resource "aws_iam_group_policy_attachment" "aws_organisations_admin_resource_groups" {
  group      = aws_iam_group.aws_organisations_admin.name
  policy_arn = "arn:aws:iam::aws:policy/ResourceGroupsandTagEditorFullAccess"
}

resource "aws_iam_group_policy_attachment" "aws_organisations_admin_custom" {
  group      = aws_iam_group.aws_organisations_admin.name
  policy_arn = aws_iam_policy.aws_organisations_admin.arn
}

################################
# AWSOrganisationsListReadOnly #
################################
resource "aws_iam_group" "aws_organisations_listreadonly" {
  name = "AWSOrganisationsListReadOnly"
  path = "/"
}

# Group policy attachments
resource "aws_iam_group_policy_attachment" "aws_organisations_listreadonly" {
  group      = aws_iam_group.aws_organisations_listreadonly.name
  policy_arn = aws_iam_policy.aws_organizations_list_read_only.arn
}

#####################
# BillingFullAccess #
#####################
resource "aws_iam_group" "billing_full_access" {
  name = "BillingFullAccess"
  path = "/"
}

# Group policy attachments
resource "aws_iam_group_policy_attachment" "billing_full_access" {
  group      = aws_iam_group.billing_full_access.name
  policy_arn = aws_iam_policy.billing_full_access.arn
}

#########################
# IAMUserChangePassword #
#########################
resource "aws_iam_group" "iam_user_change_password" {
  name = "IAMUserChangePassword"
  path = "/"
}

# Group policy attachments
resource "aws_iam_group_policy_attachment" "iam_user_change_password" {
  group      = aws_iam_group.iam_user_change_password.name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

###############################################
# ModernisationPlatformOrganisationManagement #
###############################################
resource "aws_iam_group" "modernisation_platform_organisation_management" {
  name = "ModernisationPlatformOrganisationManagement"
  path = "/"
}

# Group policy attachments
resource "aws_iam_group_policy_attachment" "modernisation_platform_organisation_management" {
  group      = aws_iam_group.modernisation_platform_organisation_management.name
  policy_arn = aws_iam_policy.terraform_organisation_management_policy.arn
}
