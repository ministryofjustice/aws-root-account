# IAM group: Admin
resource "aws_iam_group" "admins" {
  name = "Admin"
}

# Attach AWS-managed policy to the Admin group
resource "aws_iam_group_policy_attachment" "admins_administratoraccess" {
  group      = aws_iam_group.admins.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# IAM group: Artifact
resource "aws_iam_group" "artifacts" {
  name = "Artifact"
}

# Attach custom policy to the Artifact group
resource "aws_iam_group_policy_attachment" "artfiact_artifact_full_access" {
  group      = aws_iam_group.artifacts.name
  policy_arn = aws_iam_policy.artifact_full_access.arn
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

# IAM group: IAMReadOnlyGroup
resource "aws_iam_group" "iam_read_only_group" {
  name = "IAMReadOnlyGroup"
}

# Attach custom policy to the IAMReadOnlyGroup group
resource "aws_iam_group_policy_attachment" "iam_read_only_group_policy" {
  group      = aws_iam_group.iam_read_only_group.name
  policy_arn = aws_iam_policy.iam-readonly-assume-role-policy.arn
}
