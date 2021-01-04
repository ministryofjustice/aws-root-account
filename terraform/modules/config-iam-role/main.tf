###########################
# IAM role for AWS Config #
###########################
# See: https://docs.aws.amazon.com/config/latest/developerguide/gs-cli-prereq.html

data "aws_caller_identity" "current" {}

locals {
  caller_identity = data.aws_caller_identity.current
}

# Assume role policy for AWS Config
# See: https://docs.aws.amazon.com/config/latest/developerguide/iamrole-permissions.html
data "aws_iam_policy_document" "assume-role-policy" {
  version = "2012-10-17"

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }
}

# IAM role policy to access the Config S3 bucket
# See: https://docs.aws.amazon.com/config/latest/developerguide/iamrole-permissions.html
data "aws_iam_policy_document" "iam-role-policy-for-s3" {
  version = "2012-10-17"

  statement {
    sid       = "AWSConfigBucketPermissionsCheck"
    effect    = "Allow"
    actions   = ["s3:GetBucketAcl"]
    resources = [var.s3_bucket_arn]
  }

  statement {
    sid    = "AWSConfigBucketDelivery"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    resources = ["${var.s3_bucket_arn}/AWSLogs/${local.caller_identity.id}/*"]

    condition {
      test     = "StringLike"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

# IAM role policy for publishing to the SNS topics
# See: https://docs.aws.amazon.com/config/latest/developerguide/iamrole-permissions.html
data "aws_iam_policy_document" "iam-role-policy-for-sns" {
  version = "2012-10-17"

  statement {
    effect    = "Allow"
    actions   = ["sns:Publish"]
    resources = var.sns_topic_arns
  }
}

# Create IAM role policies: S3
resource "aws_iam_policy" "policy-s3" {
  name   = "AWSConfigRoleS3Access"
  policy = data.aws_iam_policy_document.iam-role-policy-for-s3.json
}

# Create IAM role policies: SNS
resource "aws_iam_policy" "policy-sns" {
  name   = "AWSConfigRoleSNSAccess"
  policy = data.aws_iam_policy_document.iam-role-policy-for-sns.json
}

# Create role for AWS Config to use
resource "aws_iam_role" "config" {
  name               = "AWSConfigRole"
  assume_role_policy = data.aws_iam_policy_document.assume-role-policy.json
}

# Attach managed AWS Config policy
# See: https://docs.aws.amazon.com/config/latest/developerguide/iamrole-permissions.html
resource "aws_iam_role_policy_attachment" "managed-policy" {
  role       = aws_iam_role.config.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

# Attach policy for S3 access
resource "aws_iam_role_policy_attachment" "s3-policy" {
  role       = aws_iam_role.config.name
  policy_arn = aws_iam_policy.policy-s3.arn
}

# Attach policy for SNS access
resource "aws_iam_role_policy_attachment" "sns-policy" {
  role       = aws_iam_role.config.name
  policy_arn = aws_iam_policy.policy-sns.arn
}
