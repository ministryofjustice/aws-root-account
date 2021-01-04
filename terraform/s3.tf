# S3 buckets in eu-west-2
## S3 bucket to store Terraform state
resource "aws_s3_bucket" "aws-root-account-terraform-state" {
  bucket = "moj-aws-root-account-terraform-state"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = local.root_account
}

resource "aws_s3_bucket_public_access_block" "aws-root-account-terraform-state" {
  bucket = aws_s3_bucket.aws-root-account-terraform-state.id

  # Block public ACLs
  block_public_acls = true

  # Block public bucket policies
  block_public_policy = true

  # Ignore public ACLs
  ignore_public_acls = true

  # Restrict public bucket policies
  restrict_public_buckets = true
}

## S3 bucket for moj-cur-reports
resource "aws_s3_bucket" "moj-cur-reports" {
  bucket = "moj-cur-reports"
  acl    = "private"

  versioning {
    enabled = true
  }
}

data "aws_iam_policy_document" "moj-cur-reports-bucket-policy" {
  version = "2008-10-17"

  # 386209384616 is owned and maintained by AWS themselves, to enable
  # upwards reporting of billing.
  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketAcl",
      "s3:GetBucketPolicy"
    ]
    resources = [aws_s3_bucket.moj-cur-reports.arn]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::386209384616:root"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.moj-cur-reports.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::386209384616:root"]
    }
  }
}

resource "aws_s3_bucket_policy" "moj-cur-reports-bucket-policy" {
  bucket = aws_s3_bucket.moj-cur-reports.bucket

  # 386209384616 is owned and maintained by AWS themselves, to enable
  # upwards reporting of billing.
  policy = data.aws_iam_policy_document.moj-cur-reports-bucket-policy.json
}

# S3 buckets in Ireland
## S3 bucket for moj-iam-credential-reports
resource "aws_s3_bucket" "moj-iam-credential-reports" {
  provider = aws.aws-root-account-eu-west-1
  bucket   = "moj-iam-credential-reports"
  acl      = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

## S3 bucket for cf-templates-rkovlae8ktmg-eu-west-1
resource "aws_s3_bucket" "cf-templates-rkovlae8ktmg-eu-west-1" {
  provider = aws.aws-root-account-eu-west-1
  bucket   = "cf-templates-rkovlae8ktmg-eu-west-1"
  acl      = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
