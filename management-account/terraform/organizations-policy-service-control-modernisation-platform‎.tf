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
    source-code   = join("", [local.github_repository, "/terraform/organizations-policy-service-control-modernisation-platform‎.tf"])
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
# Enforce S3 Block Public Access - MP Member OU scope
# Prevents public S3 bucket/object access, blocks public ACLs and policies,
# and enforces account-level S3 data protection
###############################################################

# Create the Organizations S3 policy 
resource "aws_organizations_policy" "mp_s3_block_public_access" {
  name        = "mp-s3-block-public-access"
  description = "Enforce S3 Block Public Access for accounts in the Modernisation Platform Member OU."
  type        = "S3_POLICY"

  content = jsonencode({
    s3_attributes = {
      public_access_block_configuration = {
        "@@assign" = "all"
      }
    }
  })
}

# Attach the S3 policy to the "Modernisation Platform Member" OU (applies to all accounts under it)
resource "aws_organizations_policy_attachment" "mp_member_s3_block_public_access" {
  for_each = toset([
    for child in data.aws_organizations_organizational_units.platforms_and_architecture_modernisation_platform_children.children : child.id
    if child.name == "Modernisation Platform Member"
  ])

  policy_id = aws_organizations_policy.mp_s3_block_public_access.id
  target_id = each.value
}
