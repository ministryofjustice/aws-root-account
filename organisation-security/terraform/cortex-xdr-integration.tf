data "aws_s3_objects" "cortex_xdr_templates" {
  bucket = module.cf_template_storage.bucket_name
  prefix = "cortex-xdr"
}

data "aws_s3_object" "cortex_xdr_templates" {
  for_each = toset(data.aws_s3_objects.cortex_xdr_templates.keys)
  bucket   = module.cf_template_storage.bucket_name
  key      = each.key
}

resource "random_uuid" "cortex_xdr_stack" {}

resource "random_uuid" "cortex_xdr_stack_set" {}

resource "aws_ssm_parameter" "cortex_xdr_uuids" {
  description = "Map of random UUID values used to secure external access for IAM role assumption"
  name        = "cortex_xdr_uuids"
  tags        = local.tags_organisation_management
  type        = "SecureString"
  value = jsonencode({
    xdr_stack     = random_uuid.cortex_xdr_stack.result,
    xdr_stack_set = random_uuid.cortex_xdr_stack_set.result
  })
}

resource "aws_cloudformation_stack" "cortex_xdr_stack" {
  name = "cortex-xdr-cloud-app"
  parameters = {
    CortexXDRRoleName = "CortexXDRCloudApp",
    ExternalID        = sensitive(random_uuid.cortex_xdr_stack.result)
  }
  tags          = local.tags_organisation_management
  template_body = data.aws_s3_object.cortex_xdr_templates["cortex-xdr-root-account.template"].body
}
