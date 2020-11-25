resource "aws_iam_account_alias" "default" {
  account_alias = "mojmaster"
}

data "aws_iam_policy_document" "terraform-organisation-management" {
  statement {
    sid    = "AllowOrganisationManagement"
    effect = "Allow"
    actions = [
      # Note that this doesn't grant any destructive permissions for AWS Organizations
      "iam:CreateServiceLinkedRole",
      "organizations:CreateAccount",
      "organizations:CreateOrganizationalUnit",
      "organizations:DescribeAccount",
      "organizations:DescribeCreateAccountStatus",
      "organizations:DescribeEffectivePolicy",
      "organizations:DescribeHandshake",
      "organizations:DescribeOrganization",
      "organizations:DescribeOrganizationalUnit",
      "organizations:DescribePolicy",
      "organizations:ListAccounts",
      "organizations:ListAccountsForParent",
      "organizations:ListAWSServiceAccessForOrganization",
      "organizations:ListChildren",
      "organizations:ListCreateAccountStatus",
      "organizations:ListDelegatedAdministrators",
      "organizations:ListDelegatedServicesForAccount",
      "organizations:ListHandshakesForAccount",
      "organizations:ListHandshakesForOrganization",
      "organizations:ListOrganizationalUnitsForParent",
      "organizations:ListParents",
      "organizations:ListPolicies",
      "organizations:ListPoliciesForTarget",
      "organizations:ListRoots",
      "organizations:ListTagsForResource",
      "organizations:ListTargetsForPolicy",
      "organizations:MoveAccount",
      "organizations:TagResource",
      "organizations:UntagResource",
      "organizations:UpdateOrganizationalUnit",
      "sts:*"
    ]
    resources = [
      "*"
    ]
  }

  # Allow access to the bucket from the MoJ root account
  # Policy extrapolated from:
  # https://www.terraform.io/docs/backends/types/s3.html#s3-bucket-permissions
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::modernisation-platform-terraform-state"]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::modernisation-platform-terraform-state/*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    resources = ["arn:aws:s3:::modernisation-platform-terraform-state/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_iam_policy" "terraform-organisation-management-policy" {
  name        = "TerraformOrganisationManagementPolicy"
  description = "A policy that allows the Modernisation Platform to manage organisations"
  policy      = data.aws_iam_policy_document.terraform-organisation-management.json
}

resource "aws_iam_user_policy_attachment" "terraform-organisation-management-attachment" {
  user       = aws_iam_user.user["ModernisationPlatformOrganisationManagement"].name
  policy_arn = aws_iam_policy.terraform-organisation-management-policy.arn
}
