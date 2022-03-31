module "cloudtrail" {
  source      = "../../modules/cloudtrail"
  bucket_name = module.cloudtrail_s3_bucket.bucket_name
}
