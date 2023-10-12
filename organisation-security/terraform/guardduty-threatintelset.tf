locals {
  guardduty_threatintelset = join("\n", [
    for file in fileset("./guardduty-threatintelset", "*.txt") :
    file("./guardduty-threatintelset/${file}")
  ])
}

resource "aws_s3_bucket" "guardduty_threatintelset" {}

resource "aws_s3_bucket_acl" "guardduty_threatintelset" {
  bucket = aws_s3_bucket.guardduty_threatintelset.id
  acl    = "private"
}

resource "aws_s3_object" "guardduty_threatintelset" {
  acl          = "public-read"
  bucket       = aws_s3_bucket.guardduty_threatintelset.id
  key          = "ThreatIntelSet"
  content      = local.guardduty_threatintelset
  content_type = "text/plain"
  etag         = md5(local.guardduty_threatintelset)
}
