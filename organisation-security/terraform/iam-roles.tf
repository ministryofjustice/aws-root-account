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
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.root.id}:root"]
    }
  }
}

# Role policy attachments
resource "aws_iam_role_policy_attachment" "read_only_role" {
  role       = aws_iam_role.read_only.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
