# Infrastructure to integrate cost reporting with DSIT central account: Data export, S3, and bucket replication

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
removed {
  from = module.dsit_cost_integration.aws_bcmdataexports_export.focus_report

  lifecycle {
    destroy = false
  }
}

