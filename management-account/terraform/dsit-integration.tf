# Infrastructure to integrate cost reporting with DSIT central account: Data export, S3, and bucket replication

module "dsit_infra" {
source = "[github.com/co-cddo/terraform-aws-focus?ref=v1.1.0](https://www.google.com/url?q=http%3A%2F%2Fgithub.com%2Fco-cddo%2Fterraform-aws-focus%3Fref%3Dv1.1.0&sa=D&ust=1743337080000000&usg=AOvVaw0JmgkcLkM7mKLFE3qmMv2g)"

destination_account_id = "203341582084"
destination_bucket_name = "uk-gov-gds-cost-inbound"
}