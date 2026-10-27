module "cloudtrail" {
  source      = "../../modules/cloudtrail"
  bucket_name = module.cloudtrail_s3_bucket.bucket_name
}

# Delegate CloudTrail (organisation trails) to organisation-security
resource "aws_cloudtrail_organization_delegated_admin_account" "organisation_security" {
  account_id = aws_organizations_account.organisation_security.id

  # Trusted access for cloudtrail.amazonaws.com must exist before a delegated administrator can be registered.
  depends_on = [aws_organizations_organization.default]
}
