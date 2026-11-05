data "aws_iam_policy_document" "scim_log_forwarder" {
  statement {
    sid     = "WriteSCIMLogsAndFailedInvocations"
    effect  = "Allow"
    actions = ["s3:PutObject"]
    resources = concat([
      for name in values(local.scim_log_function_names) :
      "${module.cloudtrail_s3_bucket.bucket.arn}/${local.scim_log_forwarder_prefix}${name}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
      ], [
      "${module.cloudtrail_s3_bucket.bucket.arn}/aws/lambda/async/${local.scim_log_forwarder_name}/*"
    ])

    condition {
      test     = "StringEquals"
      variable = "s3:ResourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }

  statement {
    sid       = "CheckFailedInvocationDestination"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [module.cloudtrail_s3_bucket.bucket.arn]

    condition {
      test     = "StringEquals"
      variable = "s3:ResourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }

  statement {
    sid       = "EncryptSCIMLogs"
    effect    = "Allow"
    actions   = ["kms:GenerateDataKey"]
    resources = [module.cloudtrail.kms_key_arn]

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["s3.${data.aws_region.current.region}.amazonaws.com"]
    }
  }
}
