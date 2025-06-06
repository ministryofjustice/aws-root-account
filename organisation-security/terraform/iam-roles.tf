############
# ReadOnly #
############
resource "aws_iam_role" "read_only" {
  name               = "ReadOnly"
  assume_role_policy = data.aws_iam_policy_document.read_only_role.json
}

data "aws_iam_policy_document" "read_only_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${local.root_account_id}:root",
      "arn:aws:iam::${local.organisation_security_account_id}:user/XsiamIntegration"]
    }
  }
}

# Role policy attachments
resource "aws_iam_role_policy_attachment" "read_only_role" {
  role       = aws_iam_role.read_only.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
