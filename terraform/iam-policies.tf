# AWS Organisations admin
data "aws_iam_policy_document" "aws-organisations-admin" {
  version = "2012-10-17"

  # Allow everything in organizations:*
  statement {
    effect    = "Allow"
    actions   = ["organizations:*"]
    resources = ["*"]
  }

  # But deny deletion in organizations:*
  statement {
    effect    = "Deny"
    actions   = ["organizations:Delete*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "aws-organisations-admin" {
  name        = "AWSOrganisationsAdmin"
  description = ""
  policy      = data.aws_iam_policy_document.aws-organisations-admin.json
}

# AWS Billing full access
data "aws_iam_policy_document" "billing-full-access" {
  version = "2012-10-17"

  statement {
    effect    = "Allow"
    actions   = ["aws-portal:*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "billing-full-access" {
  name        = "BillingFullAccess"
  description = "Full access to financial / billing information " # Yes, this has an extra place at the end. If you remove it, it will destroy and recreate the resource. But the IAM policy is currently in use directly through clickops, so that also needs to be imported into Terraform.
  policy      = data.aws_iam_policy_document.billing-full-access.json
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
      "sts:*",
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid    = "AllowAccessKeyProvisioning"
    effect = "Allow"
    actions = [
      "iam:CreateAccessKey",
      "iam:DeleteAccessKey",
      "iam:GetAccessKeyLastUsed",
      "iam:GetUser",
      "iam:ListAccessKeys",
      "iam:UpdateAccessKey"
    ]
    resources = ["arn:aws:iam::*:user/$${aws:username}"]
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

data "aws_iam_policy_document" "terraform-organisation-management-policy-scp" {
  source_json = data.aws_iam_policy_document.terraform-organisation-management.json

  version = "2012-10-17"

  statement {
    sid    = "AllowOrganisationManagementSCPs"
    effect = "Allow"
    actions = [
      "organizations:AttachPolicy",
      "organizations:CreatePolicy",
      "organizations:UpdatePolicy",
    ]
    resources = ["*"]
  }
  statement {
    sid    = "AllowDeleteOUs"
    effect = "Allow"
    actions = [
      # Note temporary for reorganising the ou structure, to be deleted after
      "organizations:DeleteOrganizationalUnit"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "terraform-organisation-management-policy-scp" {
  name        = "TerraformOrganisationManagementPolicyWithSCPs"
  description = "A policy that allows the Modernisation Platform to manage organisations and SCPs"
  policy      = data.aws_iam_policy_document.terraform-organisation-management-policy-scp.json
}

# SSO Administrator role, used by the Modernisation Platform to provide access to AWS accounts via AWS SSO
data "aws_iam_policy_document" "sso-administrator-role" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "identitystore:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "modernisation-platform-sso-administrator" {
  name        = "SSOAdministratorPolicy"
  description = "A policy to allow teams to manage SSO for AWS accounts"
  policy      = data.aws_iam_policy_document.sso-administrator-role.json
}
