####################################
# OIDC Provider for GitHub actions #
####################################

module "github_oidc" {
  source                 = "github.com/ministryofjustice/modernisation-platform-github-oidc-provider?ref=5dc9bc211d10c58de4247fa751c318a3985fc87b" # v4.0.0
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
    sid       = "AllowOIDCReadWizExternalId"
    effect    = "Allow"
    resources = [aws_secretsmanager_secret.wiz_external_id.arn]
    actions   = ["secretsmanager:GetSecretValue"]
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

  source = "github.com/ministryofjustice/modernisation-platform-github-oidc-role?ref=b40748ec162b446f8f8d282f767a85b6501fd192" # v4.0.0

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
      "cur:*",
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

###########################
# Xsiam Integration User #
###########################

# This will be used as a way for the Xsiam Security Hub Event Collector https://xsoar.pan.dev/docs/reference/integrations/aws-security-hub-event-collector 
# to authenticate with the org-security account.
resource "aws_iam_user" "xsiam_integration" {
  name          = "XsiamIntegration"
  path          = "/"
  force_destroy = true
  tags          = {}
}

resource "aws_iam_policy" "xsiam_integration" {
  name   = "XsiamIntegrationAccessPolicy"
  policy = data.aws_iam_policy_document.xsiam_integration.json
}

data "aws_iam_policy_document" "xsiam_integration" {
  statement {
    effect = "Allow"
    actions = [
      "securityhub:GetFindings",
      "guardduty:ListDetectors",
      "guardduty:ListFindings",
      "guardduty:GetFindings"
    ]
    resources = ["*"]
  }
}
resource "aws_iam_user_policy_attachment" "xsiam_integration" {
  user       = aws_iam_user.xsiam_integration.name
  policy_arn = aws_iam_policy.xsiam_integration.arn
}

###########################################
# Wiz read access to organisation trail   #
###########################################
# Extends the Wiz StackSet role in this account (wiz.tf) without editing the vendor template.
data "aws_iam_policy_document" "wiz_organisation_cloudtrail" {
  statement {
    sid       = "ReadTrailLogs"
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:GetObjectVersion"]
    resources = ["${local.organisation_cloudtrail_bucket_arn}/${local.organisation_cloudtrail_log_prefix}*"]
  }

  statement {
    sid       = "ListTrailLogs"
    effect    = "Allow"
    actions   = ["s3:ListBucket", "s3:GetBucketLocation"]
    resources = [local.organisation_cloudtrail_bucket_arn]
  }

  statement {
    sid       = "Decrypt"
    effect    = "Allow"
    actions   = ["kms:Decrypt", "kms:DescribeKey"]
    resources = [module.organisation_cloudtrail_kms.key_arn]
  }

  statement {
    sid    = "ConsumeNotificationQueue"
    effect = "Allow"
    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ReceiveMessage"
    ]
    resources = [module.organisation_cloudtrail_wiz_sqs.queue_arn]
  }
}

resource "aws_iam_policy" "wiz_organisation_cloudtrail" {
  count = local.wiz_enabled ? 1 : 0

  name        = local.organisation_cloudtrail_wiz_policy
  description = "Lets the Wiz role read organisation CloudTrail logs and consume their notification queue"
  policy      = data.aws_iam_policy_document.wiz_organisation_cloudtrail.json

  tags = local.organisation_cloudtrail_tags
}

resource "aws_iam_role_policy_attachment" "wiz_organisation_cloudtrail" {
  count = local.wiz_enabled ? 1 : 0

  role       = data.aws_iam_role.wiz[0].name
  policy_arn = aws_iam_policy.wiz_organisation_cloudtrail[0].arn
}
