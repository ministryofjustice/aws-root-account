##############
# S3 buckets #
##############

# cloudtrail--replication20210315101340520100000002
module "cloudtrail_replication_s3_bucket" {
  providers = {
    aws = aws.eu-west-1
  }
  source = "../../modules/s3"

  bucket_name = "cloudtrail--replication20210315101340520100000002"
}

# cloudtrail-20210315101356188000000003
module "cloudtrail_s3_bucket" {
  source = "../../modules/s3"

  bucket_name = "cloudtrail-20210315101356188000000003"
  bucket_acl  = "log-delivery-write"
}

# log-bucket-replication20210315101330747900000001
module "log_bucket_replication_s3_bucket" {
  providers = {
    aws = aws.eu-west-1
  }
  source = "../../modules/s3"

  bucket_name = "log-bucket-replication20210315101330747900000001"
}

# log-bucket20210315101344444500000002
module "log_bucket_s3_bucket" {
  source = "../../modules/s3"

  bucket_name = "log-bucket20210315101344444500000002"
}

# moj-aws-root-account-terraform-state
module "terraform_state_s3_bucket" {
  source = "../../modules/s3"

  bucket_name = "moj-aws-root-account-terraform-state"
}

# moj-cur-reports
module "cur_reports_s3_bucket" {
  source = "../../modules/s3"

  bucket_name = "moj-cur-reports"
}

# moj-cur-reports-quicksight
module "cur_reports_quicksight_s3_bucket" {
  source = "../../modules/s3"

  bucket_name = "moj-cur-reports-quicksight"
}
