##############################################
# Modernisation Platform Service Control SCP #
##############################################

##############################
# Enforce S3 KMS encryption  #
##############################

# Enforces KMS-based encryption for all S3 object writes and prevents
# removal or downgrade of bucket-level encryption configuration.
#
# !! IMPORTANT: The DenyS3PutObjectNonKMSEncryption statement uses
# StringNotEqualsIfExists, which means s3:PutObject requests that omit the
# x-amz-server-side-encryption header are ALSO denied — even when the
# destination bucket has KMS default encryption configured. Applications
# must therefore send the header explicitly. Audit affected workloads
# before expanding attachment beyond the pilot OU.
#
# Permitted algorithms: aws:kms (SSE-KMS) and aws:kms:dsse (Dual-layer
# SSE-KMS). SSE-S3 (AES256) is denied for both object writes and bucket
# encryption configuration.

resource "aws_organizations_policy" "enforce_s3_kms_encryption" {
  name        = "Enforce S3 KMS encryption"
  description = "Denies S3 object writes without explicit KMS encryption and prevents bucket encryption from being removed or downgraded to SSE-S3"
  type        = "SERVICE_CONTROL_POLICY"
  tags = {
    business-unit = "Platforms"
    component     = "SERVICE_CONTROL_POLICY"
    source-code   = join("", [local.github_repository, "/terraform/organizations-policy-service-control-modernisation-platform.tf"])
  }

  content = data.aws_iam_policy_document.enforce_s3_kms_encryption.json
}

data "aws_iam_policy_document" "enforce_s3_kms_encryption" {
  # Deny s3:PutObject unless the request header x-amz-server-side-encryption
  # is explicitly set to aws:kms or aws:kms:dsse.
  # StringNotEqualsIfExists fires when the key is absent *or* when the value
  # is not in the permitted list — covering all four previously-passing cases:
  #   (1) no SSE header,  (2) AES256,  (3) aws:kms,  (4) aws:kms + key-id.
  # Cases (3) and (4) are now the only allowed paths.
  statement {
    sid       = "DenyS3PutObjectNonKMSEncryption"
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["*"]

    condition {
      test     = "StringNotEqualsIfExists"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["aws:kms", "aws:kms:dsse"]
    }
  }

  # Deny any call that removes the bucket encryption configuration entirely.
  statement {
    sid       = "DenyS3DeleteBucketEncryption"
    effect    = "Deny"
    actions   = ["s3:DeleteBucketEncryption"]
    resources = ["*"]
  }

  # Deny PutBucketEncryption that sets or downgrades to SSE-S3.
  # StringNotEquals (without IfExists) is used because SSEAlgorithm is
  # always present in a well-formed PutBucketEncryption request body.
  statement {
    sid       = "DenyS3WeakenBucketEncryption"
    effect    = "Deny"
    actions   = ["s3:PutBucketEncryption"]
    resources = ["*"]

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["aws:kms", "aws:kms:dsse"]
    }
  }
}

# Scoped to Modernisation Platform OU only.
# Expand to wider OUs once validated — see commented rollout block below.
resource "aws_organizations_policy_attachment" "enforce_s3_kms_encryption_pilot" {
  policy_id = aws_organizations_policy.enforce_s3_kms_encryption.id
  target_id = aws_organizations_organizational_unit.platforms_and_architecture_modernisation_platform.id
}

# Wider rollout — once the pilot is validated, remove the pilot attachment
# above, uncomment the locals block and for_each resource below.
# The target list mirrors deny_non_eu_non_us_east_1_operations_targets.
#
# locals {
#   enforce_s3_kms_encryption_targets = [
#     aws_organizations_organizational_unit.central_digital.id,
#     aws_organizations_organizational_unit.cica.id,
#     aws_organizations_organizational_unit.hmcts.id,
#     aws_organizations_organizational_unit.hmpps_community_rehabilitation.id,
#     aws_organizations_organizational_unit.hmpps_electronic_monitoring_acquisitive_crime.id,
#     aws_organizations_organizational_unit.hmpps_electronic_monitoring_case_management.id,
#     aws_organizations_organizational_unit.laa.id,
#     aws_organizations_organizational_unit.opg.id,
#     aws_organizations_organizational_unit.platforms_and_architecture_cloud_platform.id,
#     aws_organizations_organizational_unit.platforms_and_architecture_modernisation_platform.id,
#     aws_organizations_organizational_unit.platforms_and_architecture_operations_engineering.id,
#     aws_organizations_organizational_unit.security_engineering.id,
#     aws_organizations_organizational_unit.technology_services.id,
#   ]
# }
#
# resource "aws_organizations_policy_attachment" "enforce_s3_kms_encryption" {
#   for_each  = toset(local.enforce_s3_kms_encryption_targets)
#   policy_id = aws_organizations_policy.enforce_s3_kms_encryption.id
#   target_id = each.value
# }
