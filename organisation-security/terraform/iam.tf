####################################
# OIDC Provider for GitHub actions #
####################################

module "github_oidc" {
  source                 = "github.com/ministryofjustice/modernisation-platform-github-oidc-provider?ref=82f546bd5f002674138a2ccdade7d7618c6758b3" # v3.0.0
  role_name              = "github-actions-plan"
  additional_permissions = data.aws_iam_policy_document.oidc_assume_role_plan.json
  github_repositories    = ["ministryofjustice/aws-root-account:pull_request"]
  tags_common            = { "Name" = "GitHub Actions Plan" }
  tags_prefix            = ""
}

data "aws_iam_policy_document" "oidc_assume_role_plan" {
  statement {
    sid       = "AllowOIDCToDecryptKMS"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["kms:Decrypt"]
  }

  statement {
    sid       = "AllowOIDCReadState"
    effect    = "Allow"
    resources = ["arn:aws:s3:::moj-aws-root-account-terraform-state/*", "arn:aws:s3:::moj-aws-root-account-terraform-state/"]
    actions = ["s3:Get*",
    "s3:List*"]
  }
}

module "github_actions_apply_role" {

  source = "github.com/ministryofjustice/modernisation-platform-github-oidc-role?ref=9d9a2d23cf569348cbdb665c979fcbaed76bb2f4" # v3.1.0

  github_repositories = ["ministryofjustice/aws-root-account"]
  role_name           = "github-actions-apply"
  policy_arns         = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  policy_jsons        = [data.aws_iam_policy_document.oidc_assume_role_apply.json]
  subject_claim       = "ref:refs/heads/main"
  tags                = { "Name" = "GitHub Actions Apply" }

}

data "aws_iam_policy_document" "oidc_assume_role_apply" {
  statement {
    effect = "Allow"
    actions = [
      "account:*AlternateContact",
      "apigateway:*",
      "budgets:*",
      "ce:*",
      "cloudtrail:*",
      "config:*",
      "cur:DescribeReportDefinitions",
      "events:*",
      "fms:*",
      "guardduty:*",
      "iam:*",
      "identitystore:ListGroups",
      "identitystore:GetGroupId",
      "identitystore:DescribeGroup",
      "kms:Decrypt",
      "lambda:*",
      "license-manager:*",
      "logs:*",
      "organizations:Describe*",
      "organizations:List*",
      "route53:*",
      "s3:*",
      "secretsmanager:*",
      "securityhub:*",
      "sns:*",
      "ec2:*"
    ]
    resources = ["*"]
  }
}
