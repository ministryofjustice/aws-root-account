################################
# AWSOrganizationsListReadOnly #
################################
resource "aws_iam_role" "aws_organizations_list_read_only" {
  name               = "AWSOrganizationsListReadOnly"
  assume_role_policy = data.aws_iam_policy_document.aws_organizations_list_read_only_role.json
}

data "aws_iam_policy_document" "aws_organizations_list_read_only_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${aws_organizations_account.moj_digital_services.id}:root",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/XsoarIntegration"]
    }
  }
}

# Role policy attachments
resource "aws_iam_role_policy_attachment" "aws_organizations_list_read_only" {
  role       = aws_iam_role.aws_organizations_list_read_only.name
  policy_arn = aws_iam_policy.aws_organizations_list_read_only.arn
}

##############################
# CostExplorerAccessReadOnly #
##############################
resource "aws_iam_role" "cost_explorer_access_read_only" {
  name               = "CostExplorerAccessReadOnly"
  assume_role_policy = data.aws_iam_policy_document.cost_explorer_access_read_only.json
}

data "aws_iam_policy_document" "cost_explorer_access_read_only" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = [
        aws_organizations_account.youth_justice_framework_management.id,
        aws_organizations_account.moj_opg_management.id
      ]
    }
  }
}

# Role policy attachments
resource "aws_iam_role_policy_attachment" "cost_explorer_access_read_only" {
  role       = aws_iam_role.cost_explorer_access_read_only.name
  policy_arn = aws_iam_policy.cost_explorer_read_only.arn
}

###############################
# lambda_basic_execution-test #
###############################
resource "aws_iam_role" "lambda_basic_execution_test" {
  name               = "lambda_basic_execution-test"
  assume_role_policy = data.aws_iam_policy_document.lambda_basic_execution_test.json
}

data "aws_iam_policy_document" "lambda_basic_execution_test" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
#########################################
# CoatGithubActionsReadonlyRole
#########################################
resource "aws_iam_role" "coat_github_actions_read_only" {
  name               = "CoatGithubActionsReadonlyRole"
  assume_role_policy = data.aws_iam_policy_document.coat_github_actions_read_only.json
}

data "aws_iam_policy_document" "coat_github_actions_read_only" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:ministryofjustice/cloud-optimisation-and-accountability:ref:refs/heads/main"]
    }
  }
}

# Role policy attachments
resource "aws_iam_role_policy_attachment" "organizations_list_read_only" {
  role       = aws_iam_role.coat_github_actions_read_only.name
  policy_arn = aws_iam_policy.aws_organizations_list_read_only.arn
}

resource "aws_iam_role_policy_attachment" "cost_optimizer_read_only" {
  role       = aws_iam_role.coat_github_actions_read_only.name
  policy_arn = aws_iam_policy.cost_optimizer_read_only.arn
}

#########################################
# ModernisationPlatformSSOAdministrator #
#########################################
resource "aws_iam_role" "modernisation_platform_sso_administrator" {
  name               = "ModernisationPlatformSSOAdministrator"
  assume_role_policy = data.aws_iam_policy_document.modernisation_platform_sso_administrator.json
}

data "aws_iam_policy_document" "modernisation_platform_sso_administrator" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${aws_organizations_account.modernisation_platform.id}:root",
        "arn:aws:iam::${coalesce(local.modernisation_platform_accounts.sprinkler_id...)}:role/github-actions"
      ]
    }
  }
}

# Role policy attachments
resource "aws_iam_role_policy_attachment" "modernisation_platform_sso_administrator" {
  role       = aws_iam_role.modernisation_platform_sso_administrator.name
  policy_arn = "arn:aws:iam::aws:policy/AWSSSOMemberAccountAdministrator"
}

resource "aws_iam_role_policy_attachment" "modernisation_platform_sso_administrator_custom" {
  role       = aws_iam_role.modernisation_platform_sso_administrator.name
  policy_arn = aws_iam_policy.sso_administrator_policy.arn
}

#########################################
# ModernisationPlatformSSOReadOnly #
#########################################
resource "aws_iam_role" "modernisation_platform_sso_readonly" {
  name               = "ModernisationPlatformSSOReadOnly"
  assume_role_policy = data.aws_iam_policy_document.modernisation_platform_sso_readonly.json
}

resource "aws_iam_policy" "modernisation_platform_sso_readonly_additional" {
  name   = "ModernisationPlatformSSOReadOnlyAdditional"
  policy = data.aws_iam_policy_document.modernisation_platform_sso_readonly_additional.json
}

data "aws_iam_policy_document" "modernisation_platform_sso_readonly" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "ForAnyValue:StringLike"
      values   = ["${data.aws_organizations_organization.root.id}/*/${aws_organizations_organizational_unit.platforms_and_architecture_modernisation_platform.id}/*"]
      variable = "aws:PrincipalOrgPaths"
    }
  }
}

data "aws_iam_policy_document" "modernisation_platform_sso_readonly_additional" {
  statement {
    effect  = "Allow"
    actions = ["identitystore:Get*"]

    resources = ["arn:aws:identitystore::${data.aws_caller_identity.current.account_id}:identitystore/*"]
  }
}

# Role policy attachments
resource "aws_iam_role_policy_attachment" "modernisation_platform_sso_readonly" {
  role       = aws_iam_role.modernisation_platform_sso_readonly.name
  policy_arn = "arn:aws:iam::aws:policy/AWSSSOReadOnly"
}

resource "aws_iam_role_policy_attachment" "modernisation_platform_ssodirectory_readonly" {
  role       = aws_iam_role.modernisation_platform_sso_readonly.name
  policy_arn = "arn:aws:iam::aws:policy/AWSSSODirectoryReadOnly"
}

resource "aws_iam_role_policy_attachment" "modernisation_platform_ssodirectory_readonly_additional" {
  role       = aws_iam_role.modernisation_platform_sso_readonly.name
  policy_arn = aws_iam_policy.modernisation_platform_sso_readonly_additional.arn
}

##########################################
# ModernisationPlatformGithubActionsRole #
##########################################

module "modernisation_platform_github_actions_role" {

  source = "github.com/ministryofjustice/modernisation-platform-github-oidc-role?ref=v3.2.0"

  github_repositories = ["ministryofjustice/modernisation-platform"]
  role_name           = "ModernisationPlatformGithubActionsRole"
  policy_arns         = [aws_iam_policy.terraform_organisation_management_policy.arn]
  policy_jsons        = [data.aws_iam_policy_document.modernisation_platform_github_actions_additional_policy.json]
  tags                = {}

}

data "aws_iam_policy_document" "modernisation_platform_github_actions_additional_policy" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "iam:GetRole"
    ]

    resources = [module.modernisation_platform_github_actions_role.role]
  }
}

##########################################
# AnalyticalPlatformIdentityCenterRole   #
##########################################

data "aws_iam_policy_document" "analytical_platform_identity_center_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${local.accounts.active_only["analytical-platform-data-production"]}:role/prod_control_panel_api20210906102154527600000001",
        "arn:aws:iam::${local.accounts.active_only["analytical-platform-development"]}:role/dev_control_panel_api20230420142935268800000001"
      ]
    }
  }
}

data "aws_iam_policy_document" "analytical_platform_identity_center" {
  #checkov:skip=CKV_AWS_158:Won't implement

  statement {
    effect = "Allow"
    actions = [
      "identitystore:CreateGroup",
      "identitystore:CreateGroupMembership",
      "identitystore:CreateUser",
      "identitystore:DeleteGroup",
      "identitystore:DeleteGroupMembership",
      "identitystore:DeleteUser",
      "identitystore:DescribeGroup",
      "identitystore:DescribeGroupMembership",
      "identitystore:ListGroupMemberships",
      "identitystore:ListGroups",
      "identitystore:ListUsers",
      "identitystore:DescribeUser",
      "identitystore:GetUserId",
      "identitystore:GetGroupId",
      "identitystore:UpdateGroup",
      "identitystore:GetGroupMembershipId",
      "identitystore:UpdateUser",
    ]
    resources = [
      "arn:aws:identitystore::${data.aws_caller_identity.current.account_id}:identitystore/*",
      "arn:aws:identitystore:::user/*",
      "arn:aws:identitystore:::group/*",
      "arn:aws:identitystore:::membership/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "sso:ListInstances",
    ]
    resources = [
      "arn:aws:sso:::instance/*"
    ]
  }
}

resource "aws_iam_policy" "analytical_platform_identity_center" {
  name   = "AnalyticalPlatformIdentityCenter"
  policy = data.aws_iam_policy_document.analytical_platform_identity_center.json
}

resource "aws_iam_role" "analytical_platform_identity_center" {
  name               = "AnalyticalPlatformIdentityCenter"
  assume_role_policy = data.aws_iam_policy_document.analytical_platform_identity_center_assume_role.json
}

resource "aws_iam_role_policy_attachment" "analytical_platform_identity_center" {
  role       = aws_iam_role.analytical_platform_identity_center.name
  policy_arn = aws_iam_policy.analytical_platform_identity_center.arn
}