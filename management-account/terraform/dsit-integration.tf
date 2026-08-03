# Infrastructure to integrate cost reporting with DSIT central account: Data export, S3, and bucket replication
module "dsit_cost_integration" {
  source = "github.com/co-cddo/terraform-aws-focus?ref=949f1318da46d6e211b440a77b42c6a90205613b" # v2.0.2

  destination_account_id                          = "203341582084"
  destination_bucket_name                         = "uk-gov-gds-cost-inbound"
  create_cost_recommendations_service_linked_role = true
}

import {
  to = module.dsit_cost_integration.aws_bcmdataexports_export.carbon["enabled"]
  id = "arn:aws:bcm-data-exports:us-east-1:${data.aws_caller_identity.current.account_id}:export/gds-carbon-v1-1b9ff508-81c4-497b-aae5-b617a4aece39"
}

import {
  to = module.dsit_cost_integration.aws_bcmdataexports_export.focus
  id = "arn:aws:bcm-data-exports:us-east-1:${data.aws_caller_identity.current.account_id}:export/gds-focus-v1-cf913b7e-c6bb-4576-aaeb-2a6f6335f3e4"
}

import {
  to = module.dsit_cost_integration.aws_bcmdataexports_export.recommendations["enabled"]
  id = "arn:aws:bcm-data-exports:us-east-1:${data.aws_caller_identity.current.account_id}:export/gds-recommendations-v1-4d32ddca-c357-494d-944f-60b775b26e33"
}

import {
  to = module.dsit_cost_integration.aws_costoptimizationhub_enrollment_status.this[0]
  id = data.aws_caller_identity.current.account_id
}

import {
  to = module.dsit_cost_integration.aws_iam_role.this
  id = "GDSCloudConsumption"
}

import {
  to = module.dsit_cost_integration.aws_iam_role_policy.replicator
  id = "GDSCloudConsumption:Replicator"
}

import {
  to = module.dsit_cost_integration.aws_iam_service_linked_role.bcm_data_exports[0]
  id = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/bcm-data-exports.amazonaws.com/AWSServiceRoleForBCMDataExports"
}

import {
  to = module.dsit_cost_integration.aws_s3_bucket.this
  id = "gds-export-${data.aws_caller_identity.current.account_id}"
}

import {
  to = module.dsit_cost_integration.aws_s3_bucket_lifecycle_configuration.this
  id = "gds-export-${data.aws_caller_identity.current.account_id}"
}

import {
  to = module.dsit_cost_integration.aws_s3_bucket_policy.this
  id = "gds-export-${data.aws_caller_identity.current.account_id}"
}

import {
  to = module.dsit_cost_integration.aws_s3_bucket_replication_configuration.this
  id = "gds-export-${data.aws_caller_identity.current.account_id}"
}

import {
  to = module.dsit_cost_integration.aws_s3_bucket_versioning.this
  id = "gds-export-${data.aws_caller_identity.current.account_id}"
}


