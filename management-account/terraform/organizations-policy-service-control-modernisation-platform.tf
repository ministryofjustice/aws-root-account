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
      test     = "ArnNotLike"
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
# Modernisation Platform OU scope
###############################################################

locals {
  mp_protected_core_s3_buckets = [
    "arn:aws:s3:::modernisation-platform-terraform-state",
    "arn:aws:s3:::modernisation-platform-terraform-state-replication",

    "arn:aws:s3:::modernisation-platform-logs-cloudtrail",
    "arn:aws:s3:::modernisation-platform-logs-cloudtrail-replication",

    "arn:aws:s3:::modernisation-platform-logs-config",
    "arn:aws:s3:::modernisation-platform-logs-config-replication",

    "arn:aws:s3:::modernisation-platform-waf-logs",
    "arn:aws:s3:::modernisation-platform-waf-logs-replication",

    "arn:aws:s3:::modernisation-platform-logs-r53-public-dns-logs",
    "arn:aws:s3:::modernisation-platform-logs-r53-public-dns-logs-replication",

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
    sid    = "DenyPutBucketPolicyOnCoreBuckets"
    effect = "Deny"
    actions = [
      "s3:PutBucketPolicy"
    ]
    resources = local.mp_protected_core_s3_buckets

    # Exclusion of automation roles for Terraform infrastructure automation
    condition {
      test     = "ArnNotLike"
      variable = "aws:PrincipalArn"
      values = [
        "arn:aws:iam::*:role/ModernisationPlatformAccess",
        "arn:aws:iam::*:role/github-actions"
      ]
    }
  }

  statement {
    sid    = "DenyDeleteBucketPolicyOnCoreBuckets"
    effect = "Deny"
    actions = [
      "s3:DeleteBucketPolicy"
    ]
    resources = local.mp_protected_core_s3_buckets
  }

  # 3) Deny changing lifecycle configuration (prevents reducing retention / disabling expiration rules)
  statement {
    sid    = "DenyLifecycleChangesOnCoreBuckets"
    effect = "Deny"
    actions = [
      "s3:PutLifecycleConfiguration"
    ]
    resources = local.mp_protected_core_s3_buckets
  }
}

resource "aws_organizations_policy_attachment" "mp_protect_core_s3_buckets" {
  policy_id = aws_organizations_policy.mp_protect_core_s3_buckets.id
  target_id = aws_organizations_organizational_unit.platforms_and_architecture_modernisation_platform.id
}


###############################################################
# Protect baseline resources from deletion
# Modernisation Platform OU scope
###############################################################

data "aws_iam_policy_document" "mp_protect_secure_baselines" {
  statement {
    sid    = "DenyDeleteSecureBaselinesResources"
    effect = "Deny"
    actions = [
      "accessanalyzer:Delete*",
      "backup:Delete*",
      "cloudtrail:Delete*",
      "cloudtrail:StopLogging",
      "cloudwatch:Delete*",
      "cloudwatch:DisableAlarmActions",
      "events:Delete*",
      "events:Remove*",
      "guardduty:Delete*",
      "kms:Delete*",
      "kms:DisableKey",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
      "logs:Delete*",
      "s3:Delete*",
      "s3:PutBucketPolicy",
      "sns:Delete*",
      "securityhub:DisableSecurityHub",
      "config:Delete*",
      "config:StopConfigurationRecorder"
    ]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/component"
      values   = ["secure-baselines"]
    }

    condition {
      test     = "ArnNotLike"
      variable = "aws:PrincipalArn"
      values = [
        "arn:aws:iam::*:role/aws-reserved/sso.amazonaws.com/*/AWSReservedSSO_AdministratorAccess*"
      ]
    }

    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalAccount"
      values = flatten([
        local.modernisation_platform_accounts.testing_test
      ])
    }
  }
}

resource "aws_organizations_policy" "mp_protect_secure_baselines" {
  name        = "Modernisation Platform Protect Secure Baselines"
  description = "Deny deletion or disabling of secure-baselines tagged resources in Modernisation Platform accounts, except AWSReservedSSO_AdministratorAccess roles."
  type        = "SERVICE_CONTROL_POLICY"

  tags = {
    business-unit = "Platforms"
    component     = "SERVICE_CONTROL_POLICY"
    source-code   = join("", [local.github_repository, "/terraform/organizations-policy-service-control-modernisation-platform.tf"])
  }

  content = data.aws_iam_policy_document.mp_protect_secure_baselines.json
}

# Attach the SCP to the Modernisation Platform OU only
resource "aws_organizations_policy_attachment" "mp_protect_secure_baselines" {
  policy_id = aws_organizations_policy.mp_protect_secure_baselines.id
  target_id = aws_organizations_organizational_unit.platforms_and_architecture_modernisation_platform.id
}

##############################
# Enforce S3 KMS encryption  #
##############################

# Enforces KMS-based encryption for S3 object writes and explicitly blocks
# setting bucket default encryption to SSE-S3 (AES256).
#
# The PutObject deny below blocks explicit SSE-S3 (AES256) writes while
# allowing requests that omit the encryption header and rely on bucket
# default encryption. Bucket-level downgrade/removal is still denied below.

resource "aws_organizations_policy" "enforce_s3_kms_encryption" {
  name        = "Enforce S3 KMS encryption"
  description = "Denies explicit SSE-S3 object writes and setting bucket default encryption to SSE-S3"
  type        = "SERVICE_CONTROL_POLICY"
  tags = {
    business-unit = "Platforms"
    component     = "SERVICE_CONTROL_POLICY"
    source-code   = join("", [local.github_repository, "/terraform/organizations-policy-service-control-modernisation-platform.tf"])
  }

  content = data.aws_iam_policy_document.enforce_s3_kms_encryption.json
}

data "aws_iam_policy_document" "enforce_s3_kms_encryption" {
  # Deny only explicit SSE-S3 object writes. Requests with no SSE header are
  # allowed so that bucket default KMS encryption can apply.
  statement {
    sid       = "DenyS3PutObjectSSES3"
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["AES256"]
    }
  }

  # Deny setting bucket default encryption to SSE-S3.
  statement {
    sid       = "DenyS3SetBucketDefaultEncryptionToSSES3"
    effect    = "Deny"
    actions   = ["s3:PutEncryptionConfiguration"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["AES256"]
    }
  }
}

# Scoped to sprinkler sub-OU only for testing.
# Do NOT attach to the parent Modernisation Platform OU — SCP inheritance would
# block Terraform state s3:PutObject calls in all other member accounts.
resource "aws_organizations_policy_attachment" "enforce_s3_kms_encryption_pilot" {
  for_each = toset([
    for child in data.aws_organizations_organizational_units.modernisation_platform_member_children_sprinkler.children :
    child.id
    if child.name == "modernisation-platform-sprinkler"
  ])

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
