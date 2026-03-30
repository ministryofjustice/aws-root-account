# Infrastructure to integrate cost reporting with DSIT central account: Data export, S3, and bucket replication

module "dsit_cost_integration" {
  source = "github.com/co-cddo/terraform-aws-focus?ref=949f1318da46d6e211b440a77b42c6a90205613b" # v2.0.2

  destination_account_id                          = "203341582084"
  destination_bucket_name                         = "uk-gov-gds-cost-inbound"
  create_cost_recommendations_service_linked_role = true
}

import {
  to = module.dsit_cost_integration.aws_costoptimizationhub_enrollment_status.this[0]
  id = data.aws_caller_identity.current.account_id
}

removed {
  from = module.dsit_cost_integration.aws_bcmdataexports_export.carbon

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.dsit_cost_integration.aws_bcmdataexports_export.focus

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.dsit_cost_integration.aws_bcmdataexports_export.recommendations

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.dsit_cost_integration.aws_costoptimizationhub_enrollment_status.this

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.dsit_cost_integration.aws_iam_role.this

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.dsit_cost_integration.aws_iam_role_policy.replicator

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.dsit_cost_integration.aws_iam_service_linked_role.bcm_data_exports

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.dsit_cost_integration.aws_s3_bucket.this

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.dsit_cost_integration.aws_s3_bucket_lifecycle_configuration.this

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.dsit_cost_integration.aws_s3_bucket_policy.this

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.dsit_cost_integration.aws_s3_bucket_replication_configuration.this

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.dsit_cost_integration.aws_s3_bucket_versioning.this

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.dsit_cost_integration.time_sleep.service_linked_role

  lifecycle {
    destroy = false
  }
}

