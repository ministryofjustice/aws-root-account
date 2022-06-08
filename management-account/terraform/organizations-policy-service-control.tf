############################
# Service Control Policies #
############################

# Note: Every AWS account must have at least *one* service control policy set. By default, this is
# "FullAWSAccess", which gives full access to all AWS services, and is automatically created.
# This cannot be edited or imported, so is not included in this Terraform.
# See https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples.html for more information

# Before creating or editing a service control policy, please read how policy inheritence works in AWS Organizations:
# https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_inheritance.html

#######################
# Alexa business deny #
#######################
resource "aws_organizations_policy" "alexa_business_deny" {
  name        = "Alexa business deny"
  description = "Alexa business deny"
  type        = "SERVICE_CONTROL_POLICY"
  tags        = {}

  content = data.aws_iam_policy_document.alexa_business_deny.json
}

data "aws_iam_policy_document" "alexa_business_deny" {
  statement {
    sid    = "Stmt1529493076000"
    effect = "Deny"
    actions = [
      "a4b:*"
    ]
    resources = ["*"]
  }
}

##############################
# Deny AWS account root user #
##############################

# Denies AWS account root user actions
# https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user.html
#
# If a team needs to use the AWS account root user (for e.g. to delete an account),
# they will need to remove this policy.

resource "aws_organizations_policy" "deny_aws_account_root_user" {
  name        = "Deny AWS account root user"
  description = "Denies the ability to use the AWS account root user (https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user.html)"
  type        = "SERVICE_CONTROL_POLICY"
  tags = {
    business-unit = "Platforms"
    component     = "SERVICE_CONTROL_POLICY"
    source-code   = join("", [local.github_repository, "/terraform/organizations-service-control-policies.tf"])
  }

  content = data.aws_iam_policy_document.deny_aws_account_root_user.json
}

data "aws_iam_policy_document" "deny_aws_account_root_user" {
  # Deny AWS account root user actions
  statement {
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "aws:PrincipalArn"
      values   = ["arn:aws:iam::*:root"]
    }
  }
}

# Attach policy to an organizational unit (i.e. target child accounts in the organizational unit)
resource "aws_organizations_policy_attachment" "deny_aws_account_root_user" {
  policy_id = aws_organizations_policy.deny_aws_account_root_user.id
  target_id = aws_organizations_organizational_unit.platforms_and_architecture.id
}

resource "aws_organizations_policy_attachment" "deny_aws_account_root_user_hmpps_community_rehabilitation" {
  policy_id = aws_organizations_policy.deny_aws_account_root_user.id
  target_id = aws_organizations_organizational_unit.hmpps_community_rehabilitation.id
}

resource "aws_organizations_policy_attachment" "deny_aws_account_root_user_cloud_platform_transit_gateways" {
  policy_id = aws_organizations_policy.deny_aws_account_root_user.id
  target_id = aws_organizations_account.cloud_platform_transit_gateways.id
}

#####################################
# Deny all actions on all resources #
#####################################

# Denies access to anything (for suspended accounts)

resource "aws_organizations_policy" "deny_all_actions_on_all_resources" {
  name        = "Deny all actions on all resources"
  description = "Denies the ability to do anything within an AWS account"
  type        = "SERVICE_CONTROL_POLICY"
  tags = {
    business-unit = "Platforms"
    component     = "SERVICE_CONTROL_POLICY"
    source-code   = join("", [local.github_repository, "/terraform/organizations-service-control-policies.tf"])
  }

  content = data.aws_iam_policy_document.deny_all_actions_on_all_resources.json
}

data "aws_iam_policy_document" "deny_all_actions_on_all_resources" {
  statement {
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]
  }
}

# Attach policy to an organizational unit (i.e. target child accounts in the organizational unit)
resource "aws_organizations_policy_attachment" "deny_all_actions_on_all_resources" {
  policy_id = aws_organizations_policy.deny_all_actions_on_all_resources.id
  target_id = aws_organizations_organizational_unit.closed_accounts.id
}

##############################################
# Deny non-EU and non-"us-east-1" operations #
##############################################

# Denies operations outside select EU regions for regional services and us-east-1 for global services
# and denies the ability to enable and deactivate regions.
#
# This policy is a more generalised version of the AWS example:
# https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples.html#examples_general
#
# By allowing general access (all actions, all resources) to us-east-1, teams can use global services
# as they become available, rather than explicitly having to list them here (as with the example above).

resource "aws_organizations_policy" "deny_non_eu_non_us_east_1_operations" {
  name        = "Deny non-EU and non-\"us-east-1\" operations"
  description = "Denies any API calls to non-default EU and non-\"us-east-1\" regions, and denies the ability to enable and deactivate opt-in regions. us-east-1 is included here as it hosts global services."
  type        = "SERVICE_CONTROL_POLICY"
  tags = {
    business-unit = "Platforms"
    component     = "SERVICE_CONTROL_POLICY"
    source-code   = join("", [local.github_repository, "/terraform/organizations-service-control-policies.tf"])
  }

  content = data.aws_iam_policy_document.deny_non_eu_non_us_east_1_operations.json
}

data "aws_iam_policy_document" "deny_non_eu_non_us_east_1_operations" {
  # Deny operations outside of select regions
  statement {
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]

    condition {
      test     = "StringNotEquals"
      variable = "aws:RequestedRegion"
      values = [
        "eu-central-1", # Europe (Frankfurt)
        "eu-west-1",    # Europe (Ireland)
        "eu-west-2",    # Europe (London)
        "us-west-2",    # US West (Oregon) (for Network Manager)
        "us-east-1",    # US East (N. Virginia) (for global services)
      ]
    }
  }

  # Deny anything apart from Network Manager in us-west-2
  statement {
    effect      = "Deny"
    not_actions = ["networkmanager:*"]
    resources   = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"
      values = [
        "us-west-2"
      ]
    }
  }

  # Deny enablement and deactivation of AWS opt-in regions (as of 04/01/2021)
  # including: Africa (Cape Town), Asia Pacific (Hong Kong), Europe (Milan), Middle East (Bahrain)
  statement {
    effect = "Deny"
    actions = [
      "account:EnableRegion",
      "account:DisableRegion"
    ]
    resources = ["*"]
  }
}

# Attach policy to lots of targets
locals {
  deny_non_eu_non_us_east_1_operations_targets = [
    # orgnaizational-unit
    aws_organizations_organizational_unit.hmpps_community_rehabilitation.id,
    aws_organizations_organizational_unit.hmpps_electronic_monitoring_acquisitive_crime.id,
    aws_organizations_organizational_unit.hmpps_electronic_monitoring_case_management.id,
    aws_organizations_organizational_unit.laa.id,
    aws_organizations_organizational_unit.opg.id,
    aws_organizations_organizational_unit.organisation_management.id,
    aws_organizations_organizational_unit.platforms_and_architecture_digital_studio_operations.id,
    aws_organizations_organizational_unit.platforms_and_architecture_modernisation_platform.id,
    aws_organizations_organizational_unit.platforms_and_architecture_operations_engineering.id,
    aws_organizations_organizational_unit.security_engineering.id,
    # organization-account
    aws_organizations_account.analytical_platform_data_engineering_sandbox.id,
    aws_organizations_account.analytical_platform_development.id,
    aws_organizations_account.analytical_platform_landing.id,
    aws_organizations_account.moj_official_development.id,
    aws_organizations_account.moj_official_network_operations_centre.id,
    aws_organizations_account.security_operations_pre_production.id,
  ]
}

resource "aws_organizations_policy_attachment" "deny_non_eu_non_us_east_1_operations" {
  for_each = toset(local.deny_non_eu_non_us_east_1_operations_targets)

  policy_id = aws_organizations_policy.deny_non_eu_non_us_east_1_operations.id
  target_id = each.value
}

########################################
# DenyCloudTrailDeleteStopUpdatePolicy #
########################################
resource "aws_organizations_policy" "deny_cloudtrail_delete_stop_update" {
  name        = "DenyCloudTrailDeleteStopUpdatePolicy"
  description = "Denies changes to CloudTrail"
  type        = "SERVICE_CONTROL_POLICY"
  tags = {
    business-unit = "LAA"
    component     = "SERVICE_CONTROL_POLICY"
    source-code   = join("", [local.github_repository, "/terraform/organizations-service-control-policies.tf"])
  }

  content = data.aws_iam_policy_document.deny_cloudtrail_delete_stop_update.json
}

data "aws_iam_policy_document" "deny_cloudtrail_delete_stop_update" {
  statement {
    effect = "Deny"
    actions = [
      "cloudtrail:UpdateTrail",
      "cloudtrail:DeleteTrail",
      "cloudtrail:StopLogging"
    ]
    resources = ["*"]
  }
}

resource "aws_organizations_policy_attachment" "deny_cloudtrail_delete_stop_update" {
  policy_id = aws_organizations_policy.deny_cloudtrail_delete_stop_update.id
  target_id = aws_organizations_organizational_unit.laa.id
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
    source-code   = join("", [local.github_repository, "/terraform/organizations-service-control-policies.tf"])
  }

  content = data.aws_iam_policy_document.modernisation_platform_member_ou_scp.json
}

data "aws_iam_policy_document" "modernisation_platform_member_ou_scp" {
  statement {
    effect = "Deny"
    actions = [
      "ec2:CreateVpcPeeringConnection",
      "ec2:CreateVpc",
      "ec2:CreateSubnet"
    ]
    resources = ["*"]
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
