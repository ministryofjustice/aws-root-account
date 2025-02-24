# This module configures an OIDC provider for use with GitHub actions.
resource "aws_iam_openid_connect_provider" "this" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  # This thumbprint is taken from the https://token.actions.githubusercontent.com certificate
  thumbprint_list = data.tls_certificate.github.certificates[*].sha1_fingerprint

  tags = var.tags
}

# Create roles
resource "aws_iam_role" "plan" {
  name               = "github-actions-plan"
  assume_role_policy = data.aws_iam_policy_document.github_oidc_assume_role_plan.json
}

data "aws_iam_policy_document" "github_oidc_assume_role_plan" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.repository_with_owner}:pull_request"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "read_only_plan" {
  role       = aws_iam_role.plan.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Add actions missing from arn:aws:iam::aws:policy/ReadOnlyAccess
resource "aws_iam_policy" "extra_permissions_plan" {
  name        = "github-actions-plan"
  path        = "/"
  description = "A policy for extra permissions for GitHub Actions"

  policy = data.aws_iam_policy_document.extra_permissions_plan.json
}

data "aws_iam_policy_document" "extra_permissions_plan" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "account:GetAlternateContact",
      "budgets:ListTagsForResource",
      "cur:DescribeReportDefinitions",
      "cur:ListTagsForResource",
      "identitystore:ListGroups",
      "identitystore:GetGroupId",
      "identitystore:DescribeGroup",
      "logs:ListTagsForResource",
      "secretsmanager:GetSecretValue",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    resources = ["arn:aws:iam::${var.organisation_security_account_id}:role/ReadOnly"]
  }
}

resource "aws_iam_role_policy_attachment" "extra_permissions_plan" {
  role       = aws_iam_role.plan.name
  policy_arn = aws_iam_policy.extra_permissions_plan.arn
}

# ===================

resource "aws_iam_role" "apply" {
  name               = "github-actions-apply"
  assume_role_policy = data.aws_iam_policy_document.github_oidc_assume_role_apply.json
}

resource "aws_iam_role_policy_attachment" "read_only_apply" {
  role       = aws_iam_role.apply.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

data "aws_iam_policy_document" "github_oidc_assume_role_apply" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.repository_with_owner}:ref:refs/heads/main"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "apply" {
  role       = aws_iam_role.apply.name
  policy_arn = aws_iam_policy.extra_permissions_apply.arn
}

resource "aws_iam_policy" "extra_permissions_apply" {
  name        = "github-actions-apply"
  path        = "/"
  description = "A policy for extra permissions for GitHub Actions"

  policy = data.aws_iam_policy_document.extra_permissions_apply.json
}

data "aws_iam_policy_document" "extra_permissions_apply" {
  statement {
    effect = "Allow"
    actions = [
      "account:*AlternateContact",
      "apigateway:*",
      "bcm-data-exports:CreateExport",
      "bcm-data-exports:GetExport",
      "bcm-data-exports:ListExports",
      "bcm-data-exports:ListTagsForResource",
      "bcm-data-exports:DeleteExport",
      "bcm-data-exports:UpdateExport",
      "bcm-data-exports:DescribeExport",
      "budgets:*",
      "ce:*",
      "cloudtrail:*",
      "config:*",
      "cur:DescribeReportDefinitions",
      "cur:ListTagsForResource",
      "cur:PutReportDefinition",
      "cur:DeleteReportDefinition",
      "events:*",
      "fms:*",
      "guardduty:*",
      "iam:*",
      "identitystore:ListGroups",
      "identitystore:GetGroupId",
      "identitystore:DescribeGroup",
      "identitystore:CreateGroup",
      "kms:Decrypt",
      "lambda:*",
      "license-manager:*",
      "logs:*",
      "organizations:AddAccountToOrganization",
      "organizations:CreateAccount",
      "organizations:CreateOrganizationalUnit",
      "organizations:CreatePolicy",
      "organizations:DescribeAccount",
      "organizations:DescribeCreateAccountStatus",
      "organizations:DescribeOrganization",
      "organizations:DisablePolicyType",
      "organizations:EnablePolicyType",
      "organizations:ListAccounts",
      "organizations:ListAccountsForParent",
      "organizations:ListOrganizationalUnitsForParent",
      "organizations:ListParents",
      "organizations:ListPoliciesForTarget",
      "organizations:ListRoots",
      "organizations:MoveAccount",
      "organizations:MoveOrganizationalUnit",
      "organizations:TagResource",
      "organizations:UpdateOrganizationalUnit",
      "organizations:UpdatePolicy",
      "organizations:UntagResource",
      "route53:*",
      "s3:*",
      "secretsmanager:*",
      "securityhub:*",
      "sns:*",
      "sso-directory:*",
      "sso:*PermissionSet*",
      "sso:*AccountAssignment*"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    resources = ["arn:aws:iam::${var.organisation_security_account_id}:role/ReadOnly"]
  }
}
