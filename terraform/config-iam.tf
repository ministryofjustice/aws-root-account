##############################
# IAM roles for AWS Config   #
##############################
# See: https://docs.aws.amazon.com/config/latest/developerguide/gs-cli-prereq.html

# Assume role policy for AWS Config
# See: https://docs.aws.amazon.com/config/latest/developerguide/iamrole-permissions.html
data "aws_iam_policy_document" "config-assume-role-policy" {
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
data "aws_iam_policy_document" "config-iam-role-policy-for-s3" {
  version = "2012-10-17"

  statement {
    sid       = "AWSConfigBucketPermissionsCheck"
    effect    = "Allow"
    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.config-bucket.arn]
  }

  statement {
    sid    = "AWSConfigBucketDelivery"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    resources = ["${aws_s3_bucket.config-bucket.arn}/AWSLogs/${local.caller_identity.id}/*"]

    condition {
      test     = "StringLike"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

# IAM role policy for publishing to the SNS topics
# See: https://docs.aws.amazon.com/config/latest/developerguide/iamrole-permissions.html
data "aws_iam_policy_document" "config-iam-role-policy-for-sns" {
  version = "2012-10-17"

  statement {
    effect  = "Allow"
    actions = ["sns:Publish"]
    resources = [
      aws_sns_topic.config-sns-topic-eu-west-2.arn
    ]
  }
}

# Create IAM role policies: S3
resource "aws_iam_policy" "config-policy-s3" {
  name   = "AWSConfigRoleS3Access"
  policy = data.aws_iam_policy_document.config-iam-role-policy-for-s3.json
}

# Create IAM role policies: SNS
resource "aws_iam_policy" "config-policy-sns" {
  name   = "AWSConfigRoleSNSAccess"
  policy = data.aws_iam_policy_document.config-iam-role-policy-for-sns.json
}

# Create role for AWS Config to use
resource "aws_iam_role" "config" {
  name               = "AWSConfigRole"
  assume_role_policy = data.aws_iam_policy_document.config-assume-role-policy.json
}

# Attach managed AWS Config policy
# See: https://docs.aws.amazon.com/config/latest/developerguide/iamrole-permissions.html
resource "aws_iam_role_policy_attachment" "config-managed-policy" {
  role       = aws_iam_role.config.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

# Attach policy for S3 access
resource "aws_iam_role_policy_attachment" "config-s3-policy" {
  role       = aws_iam_role.config.name
  policy_arn = aws_iam_policy.config-policy-s3.arn
}

# Attach policy for SNS access
resource "aws_iam_role_policy_attachment" "config-sns-policy" {
  role       = aws_iam_role.config.name
  policy_arn = aws_iam_policy.config-policy-sns.arn
}
