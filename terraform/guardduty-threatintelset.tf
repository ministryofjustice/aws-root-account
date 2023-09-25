# Moved to organisation security, leaving here whilst other guardduty resources are still dependant on it

locals {
  guardduty-threatintelset = join("\n", [
    for file in fileset("./guardduty-threatintelset", "*.txt") :
    file("./guardduty-threatintelset/${file}")
  ])
}

resource "aws_s3_bucket" "guardduty-threatintelset" {
  provider = aws.organisation-security-eu-west-2

  acl = "private"
}

resource "aws_s3_bucket_object" "guardduty-threatintelset" {
  provider = aws.organisation-security-eu-west-2

  acl          = "public-read"
  bucket       = aws_s3_bucket.guardduty-threatintelset.id
  content      = local.guardduty-threatintelset
  key          = "ThreatIntelSet"
  content_type = "text/plain"
  etag         = md5(local.guardduty-threatintelset)
}
