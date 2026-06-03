locals {
  # Dynamically include all files from guardduty-ipset directory
  # plus any additional IPs that may be generated (like GitHub Actions IPs)
  guardduty_ipset_files = [
    for file in fileset("${path.module}/guardduty-ipset", "*.txt") :
    file("${path.module}/guardduty-ipset/${file}")
  ]

  # Combine all sources: local files + dynamically fetched GitHub Actions IPs
  guardduty_ipset = join("\n", concat(
    local.guardduty_ipset_files,
    [] # Additional IP sources can be added here
  ))
}

resource "aws_s3_bucket" "guardduty_ipset" {}

resource "aws_s3_bucket_ownership_controls" "guardduty_ipset" {
  bucket = aws_s3_bucket.guardduty_ipset.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "guardduty_ipset" {
  bucket = aws_s3_bucket.guardduty_ipset.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "guardduty_ipset" {
  bucket = aws_s3_bucket.guardduty_ipset.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

data "aws_iam_policy_document" "guardduty_ipset_bucket_policy" {
  statement {
    sid    = "AllowGuardDutyServiceLinkedRoleReadIPSet"
    effect = "Allow"

    actions = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.guardduty_ipset.arn}/${aws_s3_object.guardduty_ipset.key}"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/guardduty.amazonaws.com/AWSServiceRoleForAmazonGuardDuty"]
    }
  }
}

resource "aws_s3_bucket_policy" "guardduty_ipset" {
  bucket = aws_s3_bucket.guardduty_ipset.id
  policy = data.aws_iam_policy_document.guardduty_ipset_bucket_policy.json
}

resource "aws_s3_object" "guardduty_ipset" {
  bucket       = aws_s3_bucket.guardduty_ipset.id
  key          = "IPSet"
  content      = local.guardduty_ipset
  content_type = "text/plain"
  etag         = md5(local.guardduty_ipset)

  depends_on = [
    aws_s3_bucket_ownership_controls.guardduty_ipset,
    aws_s3_bucket_server_side_encryption_configuration.guardduty_ipset
  ]
}
