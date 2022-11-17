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
      type        = "AWS"
      identifiers = ["arn:aws:iam::${aws_organizations_account.moj_digital_services.id}:root"]
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
      type        = "AWS"
      identifiers = ["arn:aws:iam::${aws_organizations_account.modernisation_platform.id}:root"]
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

##########################################
# ModernisationPlatformGithubActionsRole #
##########################################

module "modernisation_platform_github_actions_role" {

  source = "github.com/ministryofjustice/modernisation-platform-github-oidc-role?ref=v1.0.0"

  github_repositories = ["ministryofjustice/modernisation-platform:*"]
  role_name           = "ModernisationPlatformGithubActionsRole"
  policy_arns         = [aws_iam_policy.terraform_organisation_management_policy.arn]
  tags                = {}

}