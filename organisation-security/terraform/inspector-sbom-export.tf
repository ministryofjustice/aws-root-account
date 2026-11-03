#####################################
# Inspector SBOM export destination #
#####################################
# See: https://docs.aws.amazon.com/inspector/latest/user/sbom-export.html

data "aws_iam_policy_document" "inspector_sbom_export_s3_bucket" {
  statement {
    sid    = "AllowInspectorSbomExport"
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    resources = ["${module.inspector_sbom_export_s3_bucket.s3_bucket_arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["inspector2.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:inspector2:eu-west-2:${data.aws_caller_identity.current.account_id}:report/*"]
    }
  }
}

module "inspector_sbom_export_s3_bucket" {
  #checkov:skip=CKV_TF_1:Module registry does not support commit hashes for versions
  #checkov:skip=CKV_TF_2:Module registry does not support tags for versions
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.15.4"

  bucket = "moj-inspector-sbom-${data.aws_caller_identity.current.account_id}-eu-west-2"

  attach_deny_insecure_transport_policy = true
  attach_policy                         = true
  policy                                = data.aws_iam_policy_document.inspector_sbom_export_s3_bucket.json

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = module.inspector_sbom_export_kms.key_arn
        sse_algorithm     = "aws:kms"
      }
      bucket_key_enabled = true
    }
  }

  tags = merge(
    local.tags_organisation_management, {
      component = "Security"
    }
  )
}

module "inspector_sbom_export_kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "4.2.1"

  aliases                 = ["inspector/sbom-export"]
  description             = "KMS key for Amazon Inspector SBOM exports"
  enable_default_policy   = true
  enable_key_rotation     = true
  deletion_window_in_days = 30

  key_statements = [
    {
      sid    = "AllowAmazonInspectorToUseTheKey"
      effect = "Allow"
      actions = [
        "kms:Decrypt",
        "kms:GenerateDataKey*"
      ]
      resources = ["*"]

      principals = [
        {
          type        = "Service"
          identifiers = ["inspector2.amazonaws.com"]
        }
      ]

      condition = [
        {
          test     = "StringEquals"
          variable = "aws:SourceAccount"
          values   = [data.aws_caller_identity.current.account_id]
        },
        {
          test     = "ArnLike"
          variable = "aws:SourceArn"
          values   = ["arn:aws:inspector2:eu-west-2:${data.aws_caller_identity.current.account_id}:report/*"]
        }
      ]
    }
  ]

  tags = merge(
    local.tags_organisation_management, {
      component = "Security"
    }
  )
}