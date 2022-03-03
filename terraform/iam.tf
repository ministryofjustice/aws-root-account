# IAM role for S3 bucket replication
module "iam_s3_replication_role" {
  source = "github.com/ministryofjustice/modernisation-platform-terraform-s3-bucket-replication-role?ref=v3.0.0"
  buckets = [
    module.cloudtrail.s3_bucket.arn,
    module.cloudtrail.log_bucket.arn
  ]
  tags = local.root_account
}
