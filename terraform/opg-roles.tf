module "opg-sso-operator" {
  source             = "./modules/opg_role"
  name               = "opg-operator"
  user_arns          = local.opg_engineers
  custom_policy_json = data.aws_iam_policy_document.opg_operator.json
}

data "aws_iam_policy_document" "opg_operator" {
  statement {
    sid       = "AllowOrganizationsAccess"
    effect    = "Allow"
    actions   = ["organizations:*"]
    resources = ["*"]
  }
  statement {
    sid       = "AllowSSOAccess"
    effect    = "Allow"
    actions   = ["sso:*"]
    resources = ["*"]
  }
  statement {
    sid       = "AllowSSODirectoryAccess"
    effect    = "Allow"
    actions   = ["sso-directory:*"]
    resources = ["*"]
  }
  statement {
    sid       = "AllowIAMManagement"
    effect    = "Allow"
    actions   = ["iam:*"]
    resources = ["*"]
  }
}


locals {
  # I've decided to hard code our ARNs, I don't want to make this repo depend on our accounts.
  # Once SSO has been implemented we can get rid of these anyway
  opg_engineers = [
    "arn:aws:iam::631181914621:user/thomas.withers",
    "arn:aws:iam::631181914621:user/andrew.pearce",
  ]
}
