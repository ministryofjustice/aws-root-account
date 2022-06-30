# This module configures an OIDC provider for use with GitHub actions.
resource "aws_iam_openid_connect_provider" "this" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  # This thumbprint is taken from the https://token.actions.githubusercontent.com certificate
  thumbprint_list = data.tls_certificate.github.certificates[*].sha1_fingerprint

  tags = var.tags
}

# Create a role
resource "aws_iam_role" "this" {
  name               = "github-actions"
  assume_role_policy = data.aws_iam_policy_document.github_oidc_assume_role.json
}

data "aws_iam_policy_document" "github_oidc_assume_role" {
  version = "2012-10-17"

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.repository_with_owner}:ref:refs/heads/${var.repository_branch}"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "read_only" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
