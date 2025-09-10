#########################
# AWSOrganisationsAdmin #
#########################
resource "aws_iam_policy" "aws_organisations_admin" {
  name        = "AWSOrganisationsAdmin"
  description = ""
  path        = "/"
  policy      = data.aws_iam_policy_document.aws_organisations_admin.json
  tags        = {}
}

data "aws_iam_policy_document" "aws_organisations_admin" {
  version = "2012-10-17"

  # Allow everything in organizations:*
  statement {
    effect = "Allow"
    #tfsec:ignore:aws-iam-no-policy-wildcards
    actions = ["organizations:*"]
    #tfsec:ignore:aws-iam-no-policy-wildcards
    resources = ["*"]
  }

  # But deny deletion in organizations:*
  statement {
    effect  = "Deny"
    actions = ["organizations:Delete*"]
    #tfsec:ignore:aws-iam-no-policy-wildcards
    resources = ["*"]
  }
}

################################
# AWSOrganizationsListReadOnly #
################################
resource "aws_iam_policy" "aws_organizations_list_read_only" {
  name        = "AWSOrganizationsListReadOnly"
  description = "A policy to allow teams to read Organizations lists"
  path        = "/"
  policy      = data.aws_iam_policy_document.aws_organizations_list_read_only.json
  tags        = {}
}

data "aws_iam_policy_document" "aws_organizations_list_read_only" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      #tfsec:ignore:aws-iam-no-policy-wildcards
      "organizations:List*",
      "organizations:Describe*",
      "organizations:Get*"
    ]
    #tfsec:ignore:aws-iam-no-policy-wildcards
    resources = ["*"]
  }
}

#######################
# CostOptimizerReadOnly
#######################
resource "aws_iam_policy" "cost_optimizer_read_only" {
  name        = "CostOptimizerReadOnly"
  description = "Read-only access to Cost Optimization Hub"
  path        = "/"
  policy      = data.aws_iam_policy_document.cost_optimizer_read_only.json
  tags        = {}
}

data "aws_iam_policy_document" "cost_optimizer_read_only" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    #tfsec:ignore:aws-iam-no-policy-wildcards
    actions = ["cost-optimization-hub:ListRecommendations"]
    #tfsec:ignore:aws-iam-no-policy-wildcards
    resources = ["*"]
  }
}

#####################
# BillingFullAccess #
#####################
resource "aws_iam_policy" "billing_full_access" {
  name        = "BillingFullAccess"
  description = "Full access to financial / billing information "
  path        = "/"
  policy      = data.aws_iam_policy_document.billing_full_access.json
  tags        = {}
}

data "aws_iam_policy_document" "billing_full_access" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    #tfsec:ignore:aws-iam-no-policy-wildcards
    actions = ["aws-portal:*"]
    #tfsec:ignore:aws-iam-no-policy-wildcards
    resources = ["*"]
  }
}

######################
# CoatDataSyncPolicy #
######################
data "aws_iam_policy_document" "coat_datasync_iam_policy" {
  statement {
    sid    = "CoatDatasyncS3BucketPermissions"
    effect = "Allow"
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
    ]
    resources = [
      "arn:aws:s3:::${local.coat_ap_datasync_destination_bucket}"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceAccount"
      values   = ["${local.accounts.active_only["analytical-platform-data-production"]}"]
    }
  }

  statement {
    sid    = "CoatDatasyncS3ObjectPermissions"
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:GetObjectTagging",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionTagging",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
      "s3:PutObjectTagging",
    ]
    resources = [
      "arn:aws:s3:::${local.coat_ap_datasync_destination_bucket}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceAccount"
      values   = ["${local.accounts.active_only["analytical-platform-data-production"]}"]
    }
  }

  statement {
    sid    = "SourceKeyPermissions"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:GenerateDataKey",
    ]
    resources = [
      module.cur_v2_s3_kms.key_arn
    ]
  }

  statement {
    sid    = "DestinationKeyPermissions"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = [
      "arn:aws:kms:eu-west-1:${local.accounts.active_only["analytical-platform-data-production"]}:key/0409ddbc-b6a2-46c4-a613-6145f6a16215"
    ]
  }
}

module "coat_datasync_iam_policy" {
  #checkov:skip=CKV_TF_1:Module is from Terraform registry
  #checkov:skip=CKV_TF_2:Module registry does not support tags for versions

  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "6.2.1"

  name_prefix = "coat-datasync"

  policy = data.aws_iam_policy_document.coat_datasync_iam_policy.json
}

########################
# CostExplorerReadOnly #
########################
resource "aws_iam_policy" "cost_explorer_read_only" {
  name        = "CostExplorerReadOnly"
  description = "A policy to allow teams to read Cost Explorer data"
  path        = "/"
  policy      = data.aws_iam_policy_document.cost_explorer_read_only.json
  tags        = {}
}

data "aws_iam_policy_document" "cost_explorer_read_only" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    #tfsec:ignore:aws-iam-no-policy-wildcards
    actions = [
      "ce:Get*",
      "ce:List*"
    ]
    #tfsec:ignore:aws-iam-no-policy-wildcards
    resources = ["*"]
  }
}

##########################
# SSOAdministratorPolicy #
##########################
resource "aws_iam_policy" "sso_administrator_policy" {
  name        = "SSOAdministratorPolicy"
  description = "A policy to allow teams to manage SSO for AWS accounts"
  path        = "/"
  policy      = data.aws_iam_policy_document.sso_administrator_policy.json
  tags        = {}
}

data "aws_iam_policy_document" "sso_administrator_policy" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    #tfsec:ignore:aws-iam-no-policy-wildcards
    actions = ["identitystore:*"]
    #tfsec:ignore:aws-iam-no-policy-wildcards
    resources = ["*"]
  }
}

#########################################
# TerraformOrganisationManagementPolicy #
#########################################
resource "aws_iam_policy" "terraform_organisation_management_policy" {
  name        = "TerraformOrganisationManagementPolicy"
  description = "A policy that allows the Modernisation Platform to manage organisations"
  path        = "/"
  policy      = data.aws_iam_policy_document.terraform_organisation_management_policy.json
  tags        = {}
}

data "aws_iam_policy_document" "terraform_organisation_management_policy" {
  statement {
    sid    = "AllowOrganisationManagement"
    effect = "Allow"
    #tfsec:ignore:aws-iam-no-policy-wildcards
    actions = [
      # Note that this doesn't grant any destructive permissions for AWS Organizations other than OU deletion
      # OUs can only be deleted once all accounts and child ous have been deleted
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
      "organizations:DeleteOrganizationalUnit",
      "sts:*",
    ]
    #tfsec:ignore:aws-iam-no-policy-wildcards
    resources = ["*"]
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
    effect    = "Allow"
    actions   = ["s3:DeleteObject"]
    resources = ["arn:aws:s3:::modernisation-platform-terraform-state/*.tflock"]
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

  # Allow access to the key to decrypt the S3 bucket
  statement {
    effect = "Allow"
    #tfsec:ignore:aws-iam-no-policy-wildcards
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = [
      "arn:aws:kms:*:${aws_organizations_account.modernisation_platform.id}:*"
    ]

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "kms:ResourceAliases"
      values   = ["alias/s3-state-bucket"]
    }
  }
}
