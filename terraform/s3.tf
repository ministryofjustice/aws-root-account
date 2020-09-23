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
  bucket              = aws_s3_bucket.aws-root-account-terraform-state.id
  block_public_acls   = true
  block_public_policy = true
}
