########################################
# S3 account-level public access block #
########################################

resource "aws_s3_account_public_access_block" "default" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

##############
# S3 buckets #
##############

resource "random_integer" "suffix" {
  min = 10000000000
  max = 90000000000
}

# cloudtrail--replication
module "cloudtrail_replication_s3_bucket" {
  providers = {
    aws = aws.eu-west-1
  }
  source = "../../modules/s3"

  bucket_name = "cloudtrail--replication-${random_integer.suffix.result}"

  attach_policy        = true
  require_ssl_requests = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = module.cloudtrail.kms_key_arn
      }
    }
  }
}

# cloudtrail
module "cloudtrail_s3_bucket" {
  source = "../../modules/s3"

  bucket_name      = "cloudtrail-${random_integer.suffix.result}"
  bucket_acl       = "log-delivery-write"
  object_ownership = "ObjectWriter"

  attach_policy        = true
  policy               = data.aws_iam_policy_document.cloudtrail_s3_bucket.json
  require_ssl_requests = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = module.cloudtrail.kms_key_arn
      }
    }
  }
}

data "aws_iam_policy_document" "cloudtrail_s3_bucket" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::cloudtrail-${random_integer.suffix.result}"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::cloudtrail-${random_integer.suffix.result}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

# Athena
module "athena_results_s3_bucket" {
  source = "../../modules/s3"

  bucket_name = "athena-results-${random_integer.suffix.result}"
  bucket_acl  = "private"

  attach_policy        = false
  require_ssl_requests = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "aws:kms"
      }
    }
  }
}

# MP SSM Inventory Resource Data Sync S3 bucket - for syncing Modernisation Platform inventory data centrally (Similar to what's been built in organisation-security/terraform/ssm.tf but keeping this separate for now)
module "mp_ssm_inventory_resource_data_sync_s3_bucket" {
  source = "../../modules/s3"

  bucket_name = "mp-ssm-inventory-resource-data-sync-${random_integer.suffix.result}"

  attach_policy        = true
  policy               = data.aws_iam_policy_document.mp_ssm_inventory_resource_data_sync_bucket.json
  require_ssl_requests = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "aws:kms"
      }
    }
  }
}

# MP SSM Inventory Resource Data Sync S3 bucket policy
data "aws_iam_policy_document" "mp_ssm_inventory_resource_data_sync_bucket" {
  statement {
    sid    = "SSMBucketPermissionsCheck"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }
    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::mp-ssm-inventory-resource-data-sync-${random_integer.suffix.result}"]
  }

  statement {
    sid    = "SSMBucketDelivery"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::mp-ssm-inventory-resource-data-sync-${random_integer.suffix.result}/*/accountid=*/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceOrgID"
      values   = [local.organizations_organization.id]
    }
  }

  statement {
    sid    = "SSMBucketDeliveryTagging"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }
    actions   = ["s3:PutObjectTagging"]
    resources = ["arn:aws:s3:::mp-ssm-inventory-resource-data-sync-${random_integer.suffix.result}/*/accountid=*/*"]
  }
}

# KMS key for encrypting contents of the MP SSM Inventory Resource Data Sync S3 bucket
resource "aws_kms_key" "mp_ssm_inventory_resource_data_sync" {
  description         = "Used for Inventory Resource Data Sync from org member accounts"
  policy              = data.aws_iam_policy_document.mp_ssm_inventory_resource_data_sync_kms.json
  is_enabled          = true
  enable_key_rotation = true
}

resource "aws_kms_alias" "mp_ssm_inventory_resource_data_sync" {
  name          = "alias/mp-ssm-inventory-resource-data-sync"
  target_key_id = aws_kms_key.mp_ssm_inventory_resource_data_sync.key_id
}

data "aws_iam_policy_document" "mp_ssm_inventory_resource_data_sync_kms" {
  statement {
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
  statement {
    sid       = "ssm-access-policy-statement"
    effect    = "Allow"
    actions   = ["kms:GenerateDataKey"]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceOrgID"
      values   = [local.organizations_organization.id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:ssm:*:*:resource-data-sync/*"]
    }
  }
}