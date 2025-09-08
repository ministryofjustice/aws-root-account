# SOURCE - Root account S3 location
resource "aws_datasync_location_s3" "root_account" {
  s3_bucket_arn = module.cur_reports_v2_hourly_s3_bucket.s3_bucket_arn
  subdirectory  = "moj-cost-and-usage-reports/MOJ-CUR-V2-HOURLY/"

  s3_config {
    bucket_access_role_arn = "${module.coat_datasync_iam_role.arn}"
  }
}

# DESTINATION - APDP
resource "aws_datasync_location_s3" "apdp_account" {
  region        = "eu-west-1"
  s3_bucket_arn = "arn:aws:s3:::mojap-data-production-coat-cur-reports-v2-hourly"
  subdirectory  = "moj-cost-and-usage-reports/MOJ-CUR-V2-HOURLY/"

  s3_config {
    bucket_access_role_arn = "${module.coat_datasync_iam_role.arn}"
  }
}

resource "aws_datasync_task" "coat_to_apdp_task" {
  destination_location_arn = aws_datasync_location_s3.apdp_account.arn
  name                     = "root-to-apdp-coat-cur-reports"
  source_location_arn      = aws_datasync_location_s3.root_account.arn
  task_mode                = "ENHANCED"
}
