data "aws_s3_objects" "cortex_xdr_templates" {
  bucket = module.cf_template_storage.bucket_name
  prefix = "cortex-xdr"
}

data "aws_s3_object" "cortex_xdr_templates" {
  for_each = toset(data.aws_s3_objects.cortex_xdr_templates.keys)
  bucket   = module.cf_template_storage.bucket_name
  key      = each.key
}

resource "random_uuid" "cortex_xdr_stack_set" {}

resource "aws_ssm_parameter" "cortex_xdr_uuids" {
  description = "Map of random UUID values used to secure external access for IAM role assumption"
  name        = "cortex_xdr_uuids"
  tags        = local.tags_organisation_management
  type        = "SecureString"
  value = jsonencode({
    xdr_stack_set = random_uuid.cortex_xdr_stack_set.result
  })
}

resource "aws_cloudformation_stack_set" "cortex_xdr_stack_set" {
  lifecycle {
    ignore_changes = [parameters, administration_role_arn]
  }
  auto_deployment {
    enabled                          = true
    retain_stacks_on_account_removal = true
  }
  call_as      = "DELEGATED_ADMIN"
  capabilities = ["CAPABILITY_NAMED_IAM"]
  description  = "AWS CloudFormation Stack Set used by XSIAM/XDR"
  name         = "CortexXDRCloudAppStackSet"
  parameters = {
    CortexXDRRoleName = "CortexXDRCloudAppStackSet",
    ExternalID        = sensitive(random_uuid.cortex_xdr_stack_set.result)
  }
  permission_model = "SERVICE_MANAGED"
  template_body    = data.aws_s3_object.cortex_xdr_templates["cortex-xdr-subordinate-account.template"].body
  tags             = local.tags_organisation_management
}

resource "aws_cloudformation_stack_set_instance" "cortex_xdr_stack_set" {
  deployment_targets {
    organizational_unit_ids = [
      local.ou_central_digital_id,
      local.ou_cica_id,
      local.ou_hmcts_id,
      local.ou_hmpps_id,
      local.ou_laa,
      local.ou_platforms_and_architecture_id,
      local.ou_security_engineering_id,
      local.ou_technology_services,
      local.ou_yjb_id
    ]
  }
  operation_preferences {
    failure_tolerance_percentage = 100
    max_concurrent_percentage    = 33
  }
  call_as        = "DELEGATED_ADMIN"
  stack_set_name = aws_cloudformation_stack_set.cortex_xdr_stack_set.name

  lifecycle {
    ignore_changes = [
      deployment_targets[0].organizational_unit_ids,
    ]
  }
}
