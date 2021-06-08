# IAM group: Admin
resource "aws_iam_group" "admins" {
  name = "Admin"
}

# Attach AWS-managed policy to the Admin group
resource "aws_iam_group_policy_attachment" "admins_administratoraccess" {
  group      = aws_iam_group.admins.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# IAM group: AWSOrganisationsAdmin
resource "aws_iam_group" "aws_organisations_service_admins" {
  name = "AWSOrganisationsAdmin"
}

# Attach AWS-managed policy to the AWSOrganisationsAdmin group
resource "aws_iam_group_policy_attachment" "aws_organisations_service_admins_resourcegroups" {
  group      = aws_iam_group.aws_organisations_service_admins.name
  policy_arn = "arn:aws:iam::aws:policy/ResourceGroupsandTagEditorFullAccess"
}

# Attach custom policy to the AWSOrganisationsAdmin group
resource "aws_iam_group_policy_attachment" "aws_organisations_service_admins_organisation_admin_policy" {
  group      = aws_iam_group.aws_organisations_service_admins.name
  policy_arn = aws_iam_policy.aws-organisations-admin.arn
}

# IAM group: BillingFullAccess
resource "aws_iam_group" "billing_full_access" {
  name = "BillingFullAccess"
}

# Attach custom policy to the BillingFullAccess group
resource "aws_iam_group_policy_attachment" "billing_full_access_policy" {
  group      = aws_iam_group.billing_full_access.name
  policy_arn = aws_iam_policy.billing-full-access.arn
}

# IAM group: IAM Change Password
resource "aws_iam_group" "iam_user_change_password" {
  name = "IAMUserChangePassword"
}

# Attach AWS-managed policy to the IAMUserChangePassword group
resource "aws_iam_group_policy_attachment" "iam_user_change_password" {
  group      = aws_iam_group.iam_user_change_password.name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

# IAM group: ModernisationPlatformOrganisationManagement
resource "aws_iam_group" "modernisation_platform_restricted_organisations_administrator" {
  name = "ModernisationPlatformOrganisationManagement"
}

# Attach AWS-managed policy to the ModernisationPlatformOrganisationManagement
resource "aws_iam_group_policy_attachment" "modernisation_platform_restricted_organisations_administrator" {
  group      = aws_iam_group.modernisation_platform_restricted_organisations_administrator.name
  policy_arn = aws_iam_policy.terraform-organisation-management-policy.arn
}

# IAM group: ModernisationPlatformOrganisationManagementWithSCPs
resource "aws_iam_group" "modernisation_platform_restricted_organisations_scps" {
  name = "ModernisationPlatformOrganisationManagementWithSCPs"
}

# Attach AWS-managed policy to the ModernisationPlatformOrganisationManagement
resource "aws_iam_group_policy_attachment" "modernisation_platform_restricted_organisations_scps" {
  group      = aws_iam_group.modernisation_platform_restricted_organisations_scps.name
  policy_arn = aws_iam_policy.terraform-organisation-management-policy-scp.arn
}
