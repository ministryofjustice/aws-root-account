locals {
  scim_log_forwarder_name   = "scim-log-forwarder"
  scim_log_forwarder_prefix = "SCIM/"
  scim_log_groups = {
    github  = module.scim.cloudwatch_log_group_name
    entraid = module.entraid_scim.cloudwatch_log_group_name
  }
  scim_log_function_names = {
    (local.scim_log_groups.github)  = module.scim.lambda_function_name
    (local.scim_log_groups.entraid) = module.entraid_scim.lambda_function_name
  }
}

module "scim_log_forwarder" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "8.13.0"

  function_name = local.scim_log_forwarder_name
  description   = "Copies SCIM CloudWatch log batches to the CloudTrail S3 bucket"
  handler       = "handler.lambda_handler"
  runtime       = "python3.14"
  architectures = ["arm64"]
  memory_size   = 128
  timeout       = 30
  source_path   = "${path.module}/lambda/scim-log-forwarder/handler.py"
  artifacts_dir = "${path.module}/.terraform/scim-log-forwarder"

  layers = [
    "arn:aws:lambda:${data.aws_region.current.region}:017000801446:layer:AWSLambdaPowertoolsPythonV3-python314-arm64:41"
  ]

  environment_variables = {
    DESTINATION_BUCKET      = module.cloudtrail_s3_bucket.bucket_name
    DESTINATION_PREFIX      = local.scim_log_forwarder_prefix
    DESTINATION_KMS_KEY_ARN = module.cloudtrail.kms_key_arn
    SOURCE_LAMBDA_NAMES     = jsonencode(local.scim_log_function_names)
  }

  cloudwatch_logs_retention_in_days  = 30
  cloudwatch_logs_kms_key_id         = module.cloudtrail.kms_key_arn
  attach_create_log_group_permission = false
  attach_policy_json                 = true
  policy_json                        = data.aws_iam_policy_document.scim_log_forwarder.json

  create_async_event_config                 = true
  create_current_version_async_event_config = false
  maximum_event_age_in_seconds              = 21600
  maximum_retry_attempts                    = 2

  create_current_version_allowed_triggers = false
  allowed_triggers = {
    for name, log_group in local.scim_log_groups : name => {
      principal      = "logs.${data.aws_region.current.region}.amazonaws.com"
      source_account = data.aws_caller_identity.current.account_id
      source_arn     = "arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:log-group:${log_group}:*"
    }
  }
}

resource "aws_cloudwatch_log_subscription_filter" "scim_log_forwarder" {
  for_each = local.scim_log_groups

  name            = "scim-to-s3"
  log_group_name  = each.value
  filter_pattern  = ""
  destination_arn = module.scim_log_forwarder.lambda_function_arn

  depends_on = [module.scim_log_forwarder, module.cloudtrail_s3_bucket]
}
