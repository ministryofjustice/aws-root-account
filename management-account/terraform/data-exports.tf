resource "aws_bcmdataexports_export" "moj_cur_report" {
  export {
    name = "MOJ-CUR-V2-HOURLY"
    data_query {
      query_statement = "SELECT identity_line_item_id, identity_time_interval FROM COST_AND_USAGE_REPORT"
      table_configurations = {
        COST_AND_USAGE_REPORT = {
          TIME_GRANULARITY                      = "HOURLY",
          INCLUDE_RESOURCES                     = "TRUE",
          INCLUDE_MANUAL_DISCOUNT_COMPATIBILITY = "TRUE",
          INCLUDE_SPLIT_COST_ALLOCATION_DATA    = "TRUE",
        }
      }
    }
    destination_configurations {
      s3_destination {
        s3_bucket = module.cur_reports_v2_hourly_s3_bucket.bucket.bucket
        s3_prefix = "moj-cost-and-usage-reports/"
        s3_region = "eu-west-2"
        s3_output_configurations {
          overwrite   = "OVERWRITE_REPORT"
          format      = "PARQUET"
          compression = "PARQUET"
          output_type = "CUSTOM"
        }
      }
    }
    refresh_cadence {
      frequency = "SYNCHRONOUS"
    }
  }
}