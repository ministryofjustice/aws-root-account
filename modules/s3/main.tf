#############
# S3 bucket #
#############
#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "default" {
  bucket        = var.bucket_name
  bucket_prefix = var.bucket_prefix
  force_destroy = var.force_destroy

  tags = var.additional_tags
}

##############
# Bucket ACL #
##############
resource "aws_s3_bucket_acl" "default" {
  count  = var.object_ownership == "BucketOwnerEnforced" ? 0 : 1
  bucket = aws_s3_bucket.default.id
  acl    = var.bucket_acl
}

resource "aws_s3_bucket_ownership_controls" "default" {
  bucket = aws_s3_bucket.default.id
  rule {
    object_ownership = var.object_ownership
  }
}

#####################
# Bucket versioning #
#####################
resource "aws_s3_bucket_versioning" "default" {
  for_each = var.enable_versioning ? toset(["enabled"]) : []

  bucket = aws_s3_bucket.default.id

  versioning_configuration {
    status = "Enabled"
  }
}

#####################
# SSE configuration #
#####################
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  for_each = length(keys(var.server_side_encryption_configuration)) > 0 ? toset(["enabled"]) : []

  bucket = aws_s3_bucket.default.id

  dynamic "rule" {
    for_each = try(flatten([var.server_side_encryption_configuration["rule"]]), [])

    content {
      bucket_key_enabled = try(rule.value.bucket_key_enabled, null)

      dynamic "apply_server_side_encryption_by_default" {
        for_each = try([rule.value.apply_server_side_encryption_by_default], [])

        content {
          sse_algorithm     = apply_server_side_encryption_by_default.value.sse_algorithm
          kms_master_key_id = try(apply_server_side_encryption_by_default.value.kms_master_key_id, null)
        }
      }
    }
  }
}

#############################
# Object Lock Configuration #
#############################
resource "aws_s3_bucket_object_lock_configuration" "guardduty_bucket" {
  for_each = var.object_lock_enabled ? toset(["enabled"]) : []
  bucket   = aws_s3_bucket.default.id

  # rule {
  #   # There are two modes of retention: Governance, or Compliance
  #   # Governance is a soft retention period, whereas Compliance is a legal hold
  #   # that can't be bypassed and requires you to delete an AWS account in its entirety to bypass it
  #   # See: https://docs.aws.amazon.com/AmazonS3/latest/dev/object-lock-overview.html
  #   default_retention = var.object_lock_retention
  # }

  dynamic "rule" {
    for_each = try(flatten([var.object_lock_retention["rule"]]), [])

    content {
      dynamic "default_retention" {
        for_each = try([rule.value.default_retention], [])

        content {
          mode = default_retention.value.mode
          days = default_retention.value.days
        }
      }
    }
  }
}

###################
# Bucket policies #
###################
resource "aws_s3_bucket_policy" "default" {
  for_each = var.attach_policy ? toset(["enabled"]) : []

  bucket = aws_s3_bucket.default.id
  policy = data.aws_iam_policy_document.combined["enabled"].json
}

data "aws_iam_policy_document" "combined" {
  for_each = var.attach_policy ? toset(["enabled"]) : []

  source_policy_documents = compact([
    var.require_ssl_requests ? data.aws_iam_policy_document.require_ssl_requests.json : "",
    var.policy
  ])
}

# Policy to require requests to use HTTPS/SSL. This explicitly denies access HTTP requests to the bucket.
data "aws_iam_policy_document" "require_ssl_requests" {
  version = "2012-10-17"

  statement {
    sid     = "AllowSSLRequestsOnly"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      "${aws_s3_bucket.default.arn}/*",
      "${aws_s3_bucket.default.arn}"
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

##############################
# Bucket public access block #
##############################
resource "aws_s3_bucket_public_access_block" "default" {
  bucket = aws_s3_bucket.default.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

###############################
# Cross-Account Replication   #
###############################
resource "aws_s3_bucket_replication_configuration" "default" {
  depends_on = [aws_s3_bucket_versioning.default]
  for_each   = var.enable_replication ? toset(["enabled"]) : []

  role   = var.replication_role_arn
  bucket = aws_s3_bucket.default.id

  dynamic "rule" {
    for_each = var.replication_rules

    content {
      id     = rule.value.id
      status = rule.value.status

      dynamic "source_selection_criteria" {
        for_each = rule.value.kms_encrypted_objects == "Enabled" ? [1] : []
        content {
          sse_kms_encrypted_objects {
            status = rule.value.kms_encrypted_objects
          }
        }
      }
      filter {
        prefix = rule.value.prefix
      }
      destination {
        bucket = var.replication_bucket_arn
        metrics {
          status = rule.value.metrics
        }
        dynamic "encryption_configuration" {
          for_each = rule.value.replica_kms_key_id != "" ? [1] : []
          content {
            replica_kms_key_id = rule.value.replica_kms_key_id
          }
        }
      }
      delete_marker_replication {
        status = rule.value.deletemarker
      }
    }
  }
}

##############################
# IAM Policy for Replication #
##############################
resource "aws_iam_role" "replication_role" {
  count = var.enable_replication ? 1 : 0 # Create the role only if replication is enabled

  name = "${coalesce(var.bucket_name, "default-bucket-name")}-replication-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "replication" {
  count = var.enable_replication && var.enable_replication_ap_poc ? 0 : 1 # Attach policy only if replication is enabled

  name = "${aws_iam_role.replication_role[count.index].name}-policy"
  role = aws_iam_role.replication_role[count.index].id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          Sid    = "SourceBucketPermissions",
          Effect = "Allow",
          Action = [
            "s3:GetObjectVersionTagging",
            "s3:GetObjectVersionAcl",
            "s3:ListBucket",
            "s3:GetObjectVersionForReplication",
            "s3:GetReplicationConfiguration"
          ],
          Resource = [
            "arn:aws:s3:::${var.bucket_name}/*",
            "arn:aws:s3:::${var.bucket_name}"
          ]
        },
        {
          Sid    = "DestinationBucketPermissions",
          Effect = "Allow",
          Action = [
            "s3:ReplicateObject",
            "s3:ObjectOwnerOverrideToBucketOwner",
            "s3:GetObjectVersionTagging",
            "s3:ReplicateTags",
            "s3:ReplicateDelete"
          ],
          Resource = [
            "${var.replication_bucket_arn}/*",
            "${var.replication_bucket_arn}"
          ]
        },
        {
          Sid = "SourceBucketKMSKey",
          Action = [
            "kms:Decrypt",
            "kms:GenerateDataKey"
          ],
          Effect   = "Allow",
          Resource = var.source_kms_arn
        },
        {
          Sid = "DestinationBucketKMSKey",
          Action = [
            "kms:Encrypt",
            "kms:GenerateDataKey"
          ],
          Effect   = "Allow",
          Resource = var.destination_kms_arn
        }
      ]
  })
}


resource "aws_iam_role_policy" "replication_ap_poc" {
  count = var.enable_replication && var.enable_replication_ap_poc ? 1 : 0 # Attach policy only if replication is enabled

  name = "${aws_iam_role.replication_role[count.index].name}-policy"
  role = aws_iam_role.replication_role[count.index].id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          Sid    = "SourceBucketPermissions",
          Effect = "Allow",
          Action = [
            "s3:GetObjectVersionTagging",
            "s3:GetObjectVersionAcl",
            "s3:ListBucket",
            "s3:GetObjectVersionForReplication",
            "s3:GetReplicationConfiguration"
          ],
          Resource = [
            "arn:aws:s3:::${var.bucket_name}/*",
            "arn:aws:s3:::${var.bucket_name}"
          ]
        },
        {
          Sid    = "DestinationBucketPermissions",
          Effect = "Allow",
          Action = [
            "s3:ReplicateObject",
            "s3:ObjectOwnerOverrideToBucketOwner",
            "s3:GetObjectVersionTagging",
            "s3:ReplicateTags",
            "s3:ReplicateDelete"
          ],
          Resource = [
            "${var.replication_bucket_arn}/*",
            "${var.replication_bucket_arn}"
          ]
        }
      ]
  })
}

