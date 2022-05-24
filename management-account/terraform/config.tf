########################
# Config in EU regions #
########################
module "config_eu_west_2" {
  source = "../../modules/config"
  providers = {
    aws = aws.eu-west-2
  }

  create_iam_role = true
  s3_bucket_name  = module.config_log_bucket.bucket_name
}

module "config_eu_west_1" {
  source = "../../modules/config"
  providers = {
    aws = aws.eu-west-1
  }

  iam_role_arn   = module.config_eu_west_2.iam_role_arn
  s3_bucket_name = module.config_log_bucket.bucket_name
}

module "config_eu_central_1" {
  source = "../../modules/config"
  providers = {
    aws = aws.eu-central-1
  }

  iam_role_arn   = module.config_eu_west_2.iam_role_arn
  s3_bucket_name = module.config_log_bucket.bucket_name
}

########################
# Config in US regions #
########################
module "config_us_east_1" {
  providers = {
    aws = aws.us-east-1
  }

  source = "../../modules/config"

  iam_role_arn   = module.config_eu_west_2.iam_role_arn
  s3_bucket_name = module.config_log_bucket.bucket_name
}
