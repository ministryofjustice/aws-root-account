########################################
# Modernisation Platform SCP           #
########################################

# Prevents public RDS exposure, unencrypted RDS, and public snapshot sharing
# for Modernisation Platform Member OU scope

resource "aws_organizations_policy" "rds_guardrails" {
  name        = "Modernisation Platform RDS Guardrails SCP"
  description = "Prevents public RDS exposure and public snapshot sharing for Modernisation Platform pilot scope"
  type        = "SERVICE_CONTROL_POLICY"

  tags = {
    business-unit = "Platforms"
    component     = "SERVICE_CONTROL_POLICY"
    source-code   = join("", [local.github_repository, "/terraform/organizations-policy-service-control-modernisation-platform.tf"])
  }

  content = data.aws_iam_policy_document.rds_guardrails.json
}

data "aws_iam_policy_document" "rds_guardrails" {
  statement {
    sid    = "DenyRdsPubliclyAccessible"
    effect = "Deny"
    actions = [
      "rds:CreateDBInstance",
      "rds:ModifyDBInstance",
      "rds:CreateDBCluster",
      "rds:ModifyDBCluster"
    ]
    resources = ["*"]
    condition {
      test     = "Bool"
      variable = "rds:PubliclyAccessible"
      values   = ["true"]
    }
  }

  statement {
    sid    = "DenyRdsUnencrypted"
    effect = "Deny"
    actions = [
      "rds:CreateDBInstance",
      "rds:CreateDBCluster",
      "rds:RestoreDBInstanceFromDBSnapshot",
      "rds:RestoreDBInstanceToPointInTime",
      "rds:RestoreDBClusterFromSnapshot",
      "rds:RestoreDBClusterToPointInTime"
    ]
    resources = ["*"]
    condition {
      test     = "BoolIfExists"
      variable = "rds:StorageEncrypted"
      values   = ["false"]
    }
  }

  statement {
    sid    = "DenyRdsPublicSnapshotSharing"
    effect = "Deny"
    actions = [
      "rds:ModifyDBSnapshotAttribute",
      "rds:ModifyDBClusterSnapshotAttribute"
    ]
    resources = ["*"]
    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "rds:AttributeValues"
      values   = ["all"]
    }
  }
}

resource "aws_organizations_policy_attachment" "rds_guardrails" {
  for_each = toset([
    for child in data.aws_organizations_organizational_units.platforms_and_architecture_modernisation_platform_children.children : child.id
    if child.name == "Modernisation Platform Member"
  ])

  policy_id = aws_organizations_policy.rds_guardrails.id
  target_id = each.value
}


###############################################################
# Enforce S3 Block Public Access - MP OU scope
# Prevents public S3 bucket/object access, blocks public ACLs and policies,
# and enforces account-level S3 data protection
###############################################################

# Create the Organizations S3 policy
resource "aws_organizations_policy" "mp_s3_block_public_access" {
  name        = "Modernisation Platform S3 Block Public Access"
  description = "Enforce S3 Block Public Access for accounts in the Modernisation Platform Member OU."
  type        = "S3_POLICY"

  tags = {
    business-unit = "Platforms"
    component     = "S3_POLICY"
    source-code   = join("", [local.github_repository, "/terraform/organizations-policy-service-control-modernisation-platform.tf"])
  }

  content = jsonencode({
    s3_attributes = {
      public_access_block_configuration = {
        "@@assign" = "all"
      }
    }
  })
}

# Attach the S3 policy to the Modernisation Platform Member OU only
resource "aws_organizations_policy_attachment" "mp_s3_block_public_access" {
  for_each = toset([
    for child in data.aws_organizations_organizational_units.platforms_and_architecture_modernisation_platform_children.children : child.id
    if child.name == "Modernisation Platform Member"
  ])

  policy_id = aws_organizations_policy.mp_s3_block_public_access.id
  target_id = each.value
}


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
  # is not in the permitted list.
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

# Scoped to Modernisation Platform OU and sprinkler sub-OU for testing.
locals {
  enforce_s3_kms_encryption_targets = concat(
    [aws_organizations_organizational_unit.platforms_and_architecture_modernisation_platform.id],
    [
      for child in data.aws_organizations_organizational_units.modernisation_platform_member_children_sprinkler.children :
      child.id
      if child.name == "modernisation-platform-sprinkler"
    ]
  )
}

resource "aws_organizations_policy_attachment" "enforce_s3_kms_encryption_pilot" {
  for_each = toset(local.enforce_s3_kms_encryption_targets)

  policy_id = aws_organizations_policy.enforce_s3_kms_encryption.id
  target_id = each.value
}

########################################
# Modernisation Platform Member OU SCP #
########################################
resource "aws_organizations_policy" "modernisation_platform_member_ou_scp" {
  name        = "Modernisation Platform Member OU SCP"
  description = "Restricts permissions for all OUs and accounts under the Modernisation Platform Member OU"
  type        = "SERVICE_CONTROL_POLICY"

  tags = {
    business-unit = "Platforms"
    component     = "SERVICE_CONTROL_POLICY"
    source-code   = join("", [local.github_repository, "/terraform/organizations-policy-service-control-modernisation-platform.tf"])
  }

  content = data.aws_iam_policy_document.modernisation_platform_member_ou_scp.json
}

data "aws_iam_policy_document" "modernisation_platform_member_ou_scp" {
  # Deny creation of VPCs or Subnets outside of eu-west-2
  statement {
    effect = "Deny"
    actions = [
      "ec2:CreateVpc",
      "ec2:CreateSubnet"
    ]
    resources = ["*"]
    condition {
      test     = "StringNotEqualsIfExists"
      variable = "aws:RequestedRegion"
      values   = ["eu-west-2"]
    }
  }
  # block changes to OIDC provider github role
  statement {
    effect = "Deny"
    actions = [
      "iam:AttachRolePolicy",
      "iam:DeleteRole",
      "iam:DeleteRolePermissionsBoundary",
      "iam:DeleteRolePolicy",
      "iam:DetachRolePolicy",
      "iam:PutRolePermissionsBoundary",
      "iam:PutRolePolicy",
      "iam:UpdateAssumeRolePolicy",
      "iam:UpdateRole",
      "iam:UpdateRoleDescription"
    ]
    resources = ["arn:aws:iam::*:role/github-actions"]
    condition {
      test     = "StringNotLike"
      variable = "aws:PrincipalARN"
      values   = ["arn:aws:iam::*:role/OrganizationAccountAccessRole", "arn:aws:iam::*:role/ModernisationPlatformAccess", "arn:aws:iam::${coalesce(local.modernisation_platform_accounts.modernisation_platform_id...)}:role/superadmin"]
    }
  }

  # block changes to github-actions policy
  statement {
    effect = "Deny"
    actions = [
      "iam:CreatePolicy*",
      "iam:DeletePolicy*",
      "iam:SetDefaultPolicyVersion",
      "iam:TagPolicy",
      "iam:UntagPolicy"
    ]
    resources = ["arn:aws:iam::*:policy/github-actions"]
    condition {
      test     = "StringNotLike"
      variable = "aws:PrincipalARN"
      values   = ["arn:aws:iam::*:role/OrganizationAccountAccessRole", "arn:aws:iam::*:role/ModernisationPlatformAccess", "arn:aws:iam::${coalesce(local.modernisation_platform_accounts.modernisation_platform_id...)}:role/superadmin"]
    }
  }
}

resource "aws_organizations_policy_attachment" "modernisation_platform_member_ou_scp" {
  for_each = toset([
    for child in data.aws_organizations_organizational_units.platforms_and_architecture_modernisation_platform_children.children :
    child.id
    if child.name == "Modernisation Platform Member"
  ])

  target_id = each.value
  policy_id = aws_organizations_policy.modernisation_platform_member_ou_scp.id
}

###################################################
# DenyCloudTrailDeleteStopUpdatePolicy Sprinkler  #
###################################################
resource "aws_organizations_policy" "deny_cloudtrail_delete_stop_update_sprinkler" {
  name        = "DenyCloudTrailDeleteStopUpdatePolicySprinkler"
  description = "Denies DeleteTrail, StopLogging, and UpdateTrail on the 'cloudtrail' trail, except that UpdateTrail is permitted for the ModernisationPlatformAccess role, within modernisation-platform-sprinkler"
  type        = "SERVICE_CONTROL_POLICY"

  tags = {
    business-unit = "Security"
    component     = "SERVICE_CONTROL_POLICY"
    source-code   = join("", [local.github_repository, "/terraform/organizations-service-control-policies.tf"])
  }

  content = data.aws_iam_policy_document.deny_cloudtrail_delete_stop_update_sprinkler.json
}

data "aws_iam_policy_document" "deny_cloudtrail_delete_stop_update_sprinkler" {
  statement {
    sid    = "DenyDeleteTrailAndStopLogging"
    effect = "Deny"
    actions = [
      "cloudtrail:DeleteTrail",
      "cloudtrail:StopLogging"
    ]
    resources = [
      "arn:aws:cloudtrail:*:*:trail/cloudtrail"
    ]
  }

  statement {
    sid    = "DenyUpdateTrailExceptModernisationPlatformAccess"
    effect = "Deny"
    actions = [
      "cloudtrail:UpdateTrail"
    ]
    resources = [
      "arn:aws:cloudtrail:*:*:trail/cloudtrail"
    ]

    # Exclusion of ModernisationPlatformAccess role for Terraform infrastructure automation
    condition {
      test     = "StringNotLike"
      variable = "aws:PrincipalARN"
      values   = ["arn:aws:iam::*:role/ModernisationPlatformAccess"]
    }
  }
}

data "aws_organizations_organizational_units" "modernisation_platform_member_children_sprinkler" {
  parent_id = [
    for child in data.aws_organizations_organizational_units.platforms_and_architecture_modernisation_platform_children.children :
    child.id
    if child.name == "Modernisation Platform Member"
  ][0]
}

resource "aws_organizations_policy_attachment" "deny_cloudtrail_delete_stop_update_sprinkler" {
  for_each = toset([
    for child in data.aws_organizations_organizational_units.modernisation_platform_member_children_sprinkler.children :
    child.id
    if child.name == "modernisation-platform-sprinkler"
  ])

  policy_id = aws_organizations_policy.deny_cloudtrail_delete_stop_update_sprinkler.id
  target_id = each.value
}

