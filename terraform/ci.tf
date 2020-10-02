resource "aws_iam_user" "ci" {
  name = "ci"
}

resource "aws_iam_user_policy" "ci" {
  policy = data.aws_iam_policy_document.ci.json
  user   = aws_iam_user.ci.id
}

data "aws_iam_policy_document" "ci" {
  statement {
    sid       = "AllowAssumeRole"
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["*"]
  }
}

module "ci" {
  source             = "./modules/opg_role"
  name               = "ci"
  user_arns          = aws_iam_user.ci.arn
  base_policy_arn    = "arn:aws:iam::aws:policy/AdministratorAccess"
  custom_policy_json = data.aws_iam_policy_document.ci.json
}

data "aws_iam_policy_document" "ci" {
  statement {
    sid    = "DenyIAMUserCreation"
    effect = "Deny"
    actions = [
      "iam:CreateAccessKey",
      "iam:CreateLoginProfile",
      "iam:ChangePassword"
    ]
    resources = ["*"]
  }
}

