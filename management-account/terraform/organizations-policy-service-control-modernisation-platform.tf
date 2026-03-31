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

########################################
# Modernisation Platform Member OU SCP #
########################################

# Restricts permissions for all OUs and accounts under the Modernisation Platform Member OU.
# Covers VPC/subnet region locking and protection of GitHub OIDC and policy resources.

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


