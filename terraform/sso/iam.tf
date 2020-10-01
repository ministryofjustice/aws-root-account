data "external" "metadata" {
  program = [
    "bash",
    "-c",
    "jq -sR '{ content : . }' <<<$(curl -s https://${var.auth0_tenant_domain}/samlp/metadata/${auth0_client.saml.client_id})",
  ]
}

resource "aws_iam_saml_provider" "auth0" {
  name                   = "auth0"
  saml_metadata_document = data.external.metadata.result["content"]
}

resource "aws_iam_role" "auth0" {
  name                 = "auth0"
  assume_role_policy   = data.aws_iam_policy_document.auth0.json
}

resource "aws_iam_role_policy_attachment" "auth0" {
  role       = aws_iam_role.auth0.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

data "aws_iam_policy_document" "auth0" {
  statement {
    sid     = "Auth0"
    actions = ["sts:AssumeRoleWithSAML"]
    effect  = "Allow"


    principals {
      type       = "Federated"
      identifiers = [aws_iam_saml_provider.auth0.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "SAML:aud"
      values   = ["https://signin.aws.amazon.com/saml"]
    }
  }
}
