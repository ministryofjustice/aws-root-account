module "cloudtrail" {
  source      = "../../modules/cloudtrail"
  bucket_name = module.cloudtrail_s3_bucket.bucket_name
}

###########################
# Organisation CloudTrail #
###########################
# Organisation-wide management events delivered to S3, for Wiz (which reads CloudTrail only from S3 via SQS).
# The existing CloudWatch Logs collection is unchanged. Created from this account as CloudTrail delegated
# administrator; the management account owns the trail.
# See: https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-delegated-administrator.html
resource "aws_cloudtrail" "organisation" {
  name           = local.organisation_cloudtrail_name
  s3_bucket_name = module.organisation_cloudtrail_s3_bucket.s3_bucket_id
  kms_key_id     = module.organisation_cloudtrail_kms.key_arn

  is_organization_trail         = true
  is_multi_region_trail         = true
  include_global_service_events = true
  enable_log_file_validation    = true
  enable_logging                = true

  # Management events only (reads and writes); no data or Insights events.
  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }

  tags = local.organisation_cloudtrail_tags

  depends_on = [module.organisation_cloudtrail_s3_bucket, module.organisation_cloudtrail_kms]
}
