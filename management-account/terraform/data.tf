data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# KMS key for the organisation CloudTrail, which lives in organisation-security alongside its bucket
data "aws_kms_alias" "organisation_cloudtrail" {
  provider = aws.organisation-security-eu-west-2
  name     = "alias/${local.organisation_cloudtrail_name}"
}

data "aws_ssoadmin_instances" "moj" {}
