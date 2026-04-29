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

###############################################################
# Deny CloudTrail Delete/Stop/Update - MP OU scope
###############################################################
resource "aws_organizations_policy" "mp_deny_cloudtrail_delete_stop_update" {
  name        = "Modernisation Platform Deny CloudTrail Delete Stop Update"
  description = "Denies DeleteTrail, StopLogging, and UpdateTrail on the 'cloudtrail' trail for accounts in the Modernisation Platform OU, except that UpdateTrail is permitted for the ModernisationPlatformAccess role."
  type        = "SERVICE_CONTROL_POLICY"

  tags = {
    business-unit = "Security"
    component     = "SERVICE_CONTROL_POLICY"
    source-code   = join("", [local.github_repository, "/terraform/organizations-policy-service-control-modernisation-platform.tf"])
  }

  content = data.aws_iam_policy_document.mp_deny_cloudtrail_delete_stop_update.json
}

data "aws_iam_policy_document" "mp_deny_cloudtrail_delete_stop_update" {
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
      variable = "aws:PrincipalArn"
      values   = ["arn:aws:iam::*:role/ModernisationPlatformAccess"]
    }
  }
}

# Attach the SCP to the Modernisation Platform OU only
resource "aws_organizations_policy_attachment" "mp_deny_cloudtrail_delete_stop_update" {
  policy_id = aws_organizations_policy.mp_deny_cloudtrail_delete_stop_update.id
  target_id = aws_organizations_organizational_unit.platforms_and_architecture_modernisation_platform.id
}
###############################################################
# Protect core S3 buckets from deletion
# Sprinkler OU scope for testing
###############################################################

locals {
  mp_protected_core_s3_buckets = [
    "arn:aws:s3:::modernisation-platform-terraform-state",
    "arn:aws:s3:::modernisation-platform-terraform-state-replication",

    "arn:aws:s3:::modernisation-platform-logs-cloudtrail",
    "arn:aws:s3:::modernisation-platform-logs-cloudtrail-replication",

    "arn:aws:s3:::modernisation-platform-logs-cloudtrail-logging",
    "arn:aws:s3:::modernisation-platform-logs-cloudtrail-logging-replication",

    "arn:aws:s3:::modernisation-platform-logs-config",
    "arn:aws:s3:::modernisation-platform-logs-config-replication",

    "arn:aws:s3:::modernisation-platform-waf-logs",
    "arn:aws:s3:::modernisation-platform-waf-logs-replication",

    "arn:aws:s3:::modernisation-platform-logs-r53-public-dns-logs",
    "arn:aws:s3:::modernisation-platform-logs-r53-public-dns-logs-replication",

    "arn:aws:s3:::tests3scanningkf",
    "arn:aws:s3:::s3-test-scp-kf",

  ]
}

resource "aws_organizations_policy" "mp_protect_core_s3_buckets" {
  name        = "Modernisation Platform Protect Core S3 Buckets"
  description = "Denies deletion and policy/lifecycle tampering for core S3 buckets (state + core logging) in the Modernisation Platform."
  type        = "SERVICE_CONTROL_POLICY"

  tags = {
    business-unit = "Platforms"
    component     = "SERVICE_CONTROL_POLICY"
    source-code   = join("", [local.github_repository, "/terraform/organizations-policy-service-control-modernisation-platform.tf"])
  }

  content = data.aws_iam_policy_document.mp_protect_core_s3_buckets.json
}

data "aws_iam_policy_document" "mp_protect_core_s3_buckets" {
  # 1) Deny deleting the bucket itself
  statement {
    sid    = "DenyDeleteCoreBuckets"
    effect = "Deny"
    actions = [
      "s3:DeleteBucket"
    ]
    resources = local.mp_protected_core_s3_buckets
  }

  # 2) Deny changing/removing bucket policy (prevents removing other protections)
  statement {
    sid    = "DenyBucketPolicyChangesOnCoreBuckets"
    effect = "Deny"
    actions = [
      "s3:PutBucketPolicy",
      "s3:DeleteBucketPolicy"
    ]
    resources = local.mp_protected_core_s3_buckets
  }

  # 3) Deny changing lifecycle configuration (prevents reducing retention / disabling expiration rules)
  statement {
    sid    = "DenyLifecycleChangesOnCoreBuckets"
    effect = "Deny"
    actions = [
      "s3:PutLifecycleConfiguration",
      "s3:DeleteLifecycleConfiguration"
    ]
    resources = local.mp_protected_core_s3_buckets
  }
}

# Attach the SCP to the SPRINKLER OU only for testing before wider MP OU attachment
resource "aws_organizations_policy_attachment" "mp_protect_core_s3_buckets" {
  for_each = toset([
    for child in data.aws_organizations_organizational_units.mp_member_children.children : child.id
    if child.name == "modernisation-platform-sprinkler"
  ])

  policy_id = aws_organizations_policy.mp_protect_core_s3_buckets.id
  target_id = each.value
}
