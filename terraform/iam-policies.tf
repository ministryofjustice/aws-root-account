resource "aws_iam_policy" "artifact_full_access" {
  name        = "Artifact_access_Full"
  description = "Allow access to AWS Artifact"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "artifact:Get"
            ],
            "Resource": [
                "arn:aws:artifact:::report-package/Certifications and Attestations/SOC/*",
                "arn:aws:artifact:::report-package/Certifications and Attestations/PCI/*",
                "arn:aws:artifact:::report-package/Certifications and Attestations/ISO/*",
                "arn:aws:artifact:::report-package/Alignment Documents/Healthcare/*",
                "arn:aws:artifact:::report-package/Certifications and Attestations/PSN/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy" "aws-readonly-billing-access-policy" {
  name        = "aws-readonly-billing-access-policy"
  description = "This policy provides readonly access to AWS Billing Service - Cost Explorer, Billing Data"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "aws-portal:ViewUsage",
                "aws-portal:ViewBilling",
                "ce:Get*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Deny",
            "Action": [
                "aws-portal:*Account",
                "aws-portal:*Budget",
                "aws-portal:ModifyBilling",
                "aws-portal:*Payment*",
                "iam:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "aws-organisations-admin" {
  name        = "AWSOrganisationsAdmin"
  description = ""

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1508750778000",
            "Effect": "Allow",
            "Action": [
                "organizations:*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "Stmt1508750117000",
            "Effect": "Deny",
            "Action": [
                "organizations:Delete*"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy" "billing-full-access" {
  name        = "BillingFullAccess"
  description = "Full access to financial / billing information " # Yes, this has an extra place at the end. If you remove it, it will destroy and recreate the resource. But the IAM policy is currently in use directly through clickops, so that also needs to be imported into Terraform.

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1509974230000",
            "Effect": "Allow",
            "Action": [
                "aws-portal:*"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy" "iam-readonly-assume-role-policy" {
  name        = "IAMReadOnlyAssumeRolePolicy"
  description = "A policy that allows IAM Read Only access to Target Account Resources"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": {
        "Action": "sts:AssumeRole",
        "Resource": "arn:aws:iam::*:role/IAMReadOnlyAccessRole",
        "Effect": "Allow"
    }
}
EOF
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
