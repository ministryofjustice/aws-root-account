locals {
  guardduty_threatintelset = join("\n", [
    for file in fileset("./guardduty-threatintelset", "*.txt") :
    file("./guardduty-threatintelset/${file}")
  ])
}

resource "aws_s3_bucket" "guardduty_threatintelset" {}

resource "aws_s3_bucket_ownership_controls" "guardduty_threatintelset" {
  bucket = aws_s3_bucket.guardduty_threatintelset.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "guardduty_threatintelset" {
  bucket = aws_s3_bucket.guardduty_threatintelset.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "guardduty_threatintelset" {
  bucket = aws_s3_bucket.guardduty_threatintelset.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

data "aws_iam_policy_document" "guardduty_threatintelset_bucket_policy" {
  statement {
    sid    = "AllowGuardDutyServiceLinkedRoleReadThreatIntelSet"
    effect = "Allow"

    actions = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.guardduty_threatintelset.arn}/${aws_s3_object.guardduty_threatintelset.key}"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/guardduty.amazonaws.com/AWSServiceRoleForAmazonGuardDuty"]
    }
  }
}

resource "aws_s3_bucket_policy" "guardduty_threatintelset" {
  bucket = aws_s3_bucket.guardduty_threatintelset.id
  policy = data.aws_iam_policy_document.guardduty_threatintelset_bucket_policy.json
}

resource "aws_s3_object" "guardduty_threatintelset" {
  bucket       = aws_s3_bucket.guardduty_threatintelset.id
  key          = "ThreatIntelSet"
  content      = local.guardduty_threatintelset
  content_type = "text/plain"
  etag         = md5(local.guardduty_threatintelset)

  depends_on = [
    aws_s3_bucket_ownership_controls.guardduty_threatintelset,
    aws_s3_bucket_server_side_encryption_configuration.guardduty_threatintelset
  ]
}
