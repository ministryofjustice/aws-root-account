# Infrastructure to integrate cost reporting with DSIT central account: Data export, S3, and bucket replication

module "dsit_cost_integration" {
  source = "github.com/co-cddo/terraform-aws-focus?ref=949f1318da46d6e211b440a77b42c6a90205613b" # v2.0.2

  destination_account_id  = "203341582084"
  destination_bucket_name = "uk-gov-gds-cost-inbound"
}

import {
  to = module.dsit_cost_integration.aws_costoptimizationhub_enrollment_status.this[0]
  id = data.aws_caller_identity.current.account_id
}
