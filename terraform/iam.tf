data "aws_iam_policy_document" "organisation-management" {
  statement {
    sid = "DenyAllApartFromOrganisationManagement"
    effect = "Deny"
    actions = ["*"]
    not_actions = [
      # Note that this doesn't allow the account to delete Organisational Units
      "organizations:DescribeOrganization",
      "organizations:DescribeOrganizationalUnit",
      "organizations:CreateOrganizationalUnit",
      "organizations:UpdateOrganizationalUnit",
      "organizations:CreateAccount",
      "organizations:MoveAccount",
      "iam:CreateServiceLinkedRole"
    ]
  }
}

resource "aws_iam_user" "terraform-organisation-management" {
  name = "TerraformOrganisationManagement"
}

resource "aws_iam_policy" "terraform-organisation-management-policy" {
  name = "TerraformOrganisationManagementPolicy"
  description = "A policy that allows Terraform to only manage organisations"
  policy = data.aws_iam_policy_document.organisation-management.json
}

resource "aws_iam_user_policy_attachment" "terraform-organisation-management-policy-attachment" {
  user = aws_iam_user.terraform-organisation-management.name
  policy_arn = aws_iam_policy.terraform-organisation-management-policy.arn
}
