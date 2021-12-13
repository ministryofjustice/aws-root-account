locals {
  guardduty-threatintelset = join("\n", [
    for file in fileset("./guardduty-threatintelset", "*.txt") :
    file("./guardduty-threatintelset/${file}")
  ])
}

resource "aws_s3_bucket" "guardduty-threatintelset" {
  acl = "private"
}

resource "aws_s3_bucket_object" "guardduty-threatintelset" {
  acl     = "public-read"
  bucket  = aws_s3_bucket.guardduty-threatintelset.id
  content = local.guardduty-threatintelset
  key     = "ThreatIntelSet"
}
