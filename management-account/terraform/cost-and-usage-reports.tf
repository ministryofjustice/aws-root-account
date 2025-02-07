resource "aws_cur_report_definition" "no_integrations" {
  provider = aws.us-east-1

  report_name                = "MOJ-CUR"
  time_unit                  = "DAILY"
  format                     = "textORcsv"
  compression                = "ZIP"
  additional_schema_elements = ["RESOURCES"]
  additional_artifacts       = []
  refresh_closed_reports     = true
  report_versioning          = "CREATE_NEW_REPORT"

  # S3 configuration
  s3_bucket = module.cur_reports_s3_bucket.bucket_name
  s3_region = "eu-west-2"
  s3_prefix = "CUR"
}

resource "aws_cur_report_definition" "quicksight_integration" {
  provider = aws.us-east-1

  report_name                = "MOJ-CUR-QUICKSIGHT-INTEGRATION"
  time_unit                  = "DAILY"
  format                     = "textORcsv"
  compression                = "ZIP"
  additional_schema_elements = ["RESOURCES"]
  additional_artifacts       = ["REDSHIFT", "QUICKSIGHT"]
  refresh_closed_reports     = true
  report_versioning          = "CREATE_NEW_REPORT"

  # S3 configuration
  s3_bucket = module.cur_reports_quicksight_s3_bucket.bucket_name
  s3_region = "eu-west-2"
  s3_prefix = "CUR"
}

resource "aws_cur_report_definition" "athena_integration" {
  provider = aws.us-east-1

  report_name                = "MOJ-CUR-ATHENA"
  time_unit                  = "DAILY"
  format                     = "Parquet"
  compression                = "Parquet"
  additional_schema_elements = ["RESOURCES", "SPLIT_COST_ALLOCATION_DATA"]
  additional_artifacts       = ["ATHENA"]
  refresh_closed_reports     = true
  report_versioning          = "OVERWRITE_REPORT"

  # S3 configuration
  s3_bucket = module.cur_reports_s3_bucket.bucket_name
  s3_region = "eu-west-2"
  s3_prefix = "CUR-ATHENA"
}


resource "aws_cur_report_definition" "moj_cur_report" {
  provider = aws.us-east-1

  report_name                = "MOJ-CUR-V2-HOURLY"
  time_unit                  = "HOURLY"
  format                     = "Parquet"
  compression                = "Parquet"
  additional_schema_elements = ["RESOURCES", "SPLIT_COST_ALLOCATION_DATA"]
  additional_artifacts       = ["ATHENA"]
  report_versioning          = "OVERWRITE_REPORT"

  # S3 configuration
  s3_bucket = module.cur_reports_v2_hourly_s3_bucket.bucket_name
  s3_region = "eu-west-2"
  s3_prefix = "moj-cost-and-usage-reports/"
}

