data "aws_organizations_organization" "org" {}

locals {
  account_ids = {
    for account in data.aws_organizations_organization.org.accounts :
    lower(account.email) => account.id
  }
}

resource "aws_iam_role" "terraform-modernisation-platform-organisation-management-role" {
  name               = "ModernisationPlatformOrganisationManagementRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${local.account_ids["aws+modernisation-platform@digital.justice.gov.uk"]}:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "organisation-management" {
  statement {
    sid    = "AllowOrganisationManagement"
    effect = "Allow"
    actions = [
      # Note that this doesn't grant any destructive permissions for AWS Organizations
      "organizations:ListRoots",
      "organizations:ListDelegatedServicesForAccount",
      "organizations:DescribeAccount",
      "organizations:UntagResource",
      "organizations:CreateAccount",
      "organizations:DescribePolicy",
      "organizations:ListChildren",
      "organizations:TagResource",
      "organizations:ListCreateAccountStatus",
      "organizations:DescribeOrganization",
      "organizations:DescribeOrganizationalUnit",
      "organizations:MoveAccount",
      "organizations:DescribeHandshake",
      "organizations:DescribeCreateAccountStatus",
      "organizations:ListPoliciesForTarget",
      "organizations:DescribeEffectivePolicy",
      "organizations:ListTargetsForPolicy",
      "organizations:ListTagsForResource",
      "organizations:ListAWSServiceAccessForOrganization",
      "organizations:ListPolicies",
      "organizations:ListDelegatedAdministrators",
      "organizations:ListAccountsForParent",
      "organizations:ListHandshakesForOrganization",
      "organizations:ListHandshakesForAccount",
      "organizations:ListAccounts",
      "organizations:UpdateOrganizationalUnit",
      "iam:CreateServiceLinkedRole",
      "organizations:ListParents",
      "organizations:ListOrganizationalUnitsForParent",
      "organizations:CreateOrganizationalUnit"
    ]
    resources = [
      "arn:aws:organizations:::*"
    ]
  }
}

resource "aws_iam_policy" "terraform-organisation-management-policy" {
  name        = "TerraformOrganisationManagementPolicy"
  description = "A policy that allows the Modernisation Platform to manage organisations"
  policy      = data.aws_iam_policy_document.organisation-management.json
}

resource "aws_iam_role_policy_attachment" "terraform-organisation-management-attachment" {
  role       = aws_iam_role.terraform-modernisation-platform-organisation-management-role.name
  policy_arn = aws_iam_policy.terraform-organisation-management-policy.arn
}
