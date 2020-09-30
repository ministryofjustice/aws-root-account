resource "aws_iam_role" "role" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.role.json
}

data "aws_iam_policy_document" "role" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.user_arns
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "base" {
  role       = aws_iam_role.role.id
  policy_arn = var.base_policy_arn
}

resource "aws_iam_role_policy" "custom" {
  count  = var.custom_policy_json != "" ? 1 : 0
  policy = var.custom_policy_json
  role   = aws_iam_role.role.id
}