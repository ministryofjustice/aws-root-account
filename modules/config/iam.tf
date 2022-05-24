resource "aws_iam_role" "config" {
  for_each = var.create_iam_role ? toset(["enabled"]) : toset([])

  name               = "AWSConfigRole"
  assume_role_policy = data.aws_iam_policy_document.config.json
}

data "aws_iam_policy_document" "config" {
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

# Attach managed AWS_ConfigRole policy
resource "aws_iam_role_policy_attachment" "aws_managed" {
  for_each = var.create_iam_role ? toset(["enabled"]) : toset([])

  role       = aws_iam_role.config["enabled"].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

# IAM policy for S3
resource "aws_iam_policy" "s3" {
  for_each = var.create_iam_role ? toset(["enabled"]) : toset([])

  name   = "AWSConfigRoleS3Access"
  policy = data.aws_iam_policy_document.s3.json
}

data "aws_iam_policy_document" "s3" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]
    resources = ["arn:aws:s3:::${var.s3_bucket_name}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    condition {
      test     = "StringLike"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::${var.s3_bucket_name}"]
  }
}

resource "aws_iam_role_policy_attachment" "s3" {
  for_each = var.create_iam_role ? toset(["enabled"]) : toset([])

  role       = aws_iam_role.config["enabled"].name
  policy_arn = aws_iam_policy.s3["enabled"].arn
}
