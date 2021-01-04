# AWS Config IAM role with necessary permissions to send resource changes to
# an aggregation S3 bucket, configured in config-aggregation.tf within the
# organisation-security account.
module "config-iam-role" {
  source = "./modules/config-iam-role"

  s3_bucket_arn = module.config-aggregation-bucket.s3_bucket_arn
  sns_topic_arns = [
    module.config-aggregation-sns-eu-west-2.sns_topic_arn
  ]
}

# Enable Config for the default region in the AWS root account
module "config-default-region" {
  source = "./modules/config"

  s3_bucket_name = module.config-aggregation-bucket.s3_bucket_name
  sns_topic_arn  = module.config-aggregation-sns-eu-west-2.sns_topic_arn
  iam_role_arn   = module.config-iam-role.role_arn
  home_region    = "eu-west-2"
}
