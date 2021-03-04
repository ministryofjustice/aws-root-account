resource "aws_cur_report_definition" "default" {
  # AWS Cost and Usage Reports are only available via us-east-1 APIs, so
  # we set the provider for this resource to be us-east-1
  provider = aws.aws-root-account-us-east-1

  report_name                = "MOJ-CUR"
  time_unit                  = "DAILY"
  format                     = "textORcsv"
  compression                = "ZIP"
  additional_schema_elements = ["RESOURCES"]
  additional_artifacts       = []
  refresh_closed_reports     = false

  # S3 configuration
  s3_bucket = aws_s3_bucket.moj-cur-reports.bucket
  s3_prefix = "CUR"
  s3_region = "eu-west-2"
}
