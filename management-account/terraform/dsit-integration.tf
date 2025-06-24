# Infrastructure to integrate cost reporting with DSIT central account: Data export, S3, and bucket replication

module "dsit_cost_integration" {
  source = "github.com/co-cddo/terraform-aws-focus?ref=v1.2.0"

  destination_account_id  = "203341582084"
  destination_bucket_name = "uk-gov-gds-cost-inbound"
}