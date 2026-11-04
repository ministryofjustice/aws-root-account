module "cloudtrail" {
  source      = "../../modules/cloudtrail"
  bucket_name = module.cloudtrail_s3_bucket.bucket_name
}

# Delegate CloudTrail (organisation trails) to organisation-security
resource "aws_cloudtrail_organization_delegated_admin_account" "organisation_security" {
  account_id = aws_organizations_account.organisation_security.id

  # Trusted access for cloudtrail.amazonaws.com must exist before a delegated administrator can be registered,
  # and the apply role needs organizations:RegisterDelegatedAdministrator (granted in module.github_oidc).
  depends_on = [aws_organizations_organization.default, module.github_oidc]
}

###########################
# Organisation CloudTrail #
###########################
# Organisation-wide management events delivered to the organisation-security bucket, for Wiz (which reads
# CloudTrail only from S3 via SQS). The bucket, key, topic and queue are managed in organisation-security.
# Managed here because the management account owns organisation trails: when organisation-security created it as
# delegated administrator, the provider could not read it back (DescribeTrails rejects the management account ARN).
resource "aws_cloudtrail" "organisation" {
  name           = local.organisation_cloudtrail_name
  s3_bucket_name = local.organisation_cloudtrail_bucket_name
  kms_key_id     = data.aws_kms_alias.organisation_cloudtrail.target_key_arn

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
}
