resource "aws_secretsmanager_secret" "auth0_client_secret" {
  name = "example"
}

data "aws_secretsmanager_secret_version" "auth0_client_secret" {
  secret_id = aws_secretsmanager_secret.auth0_client_secret.id
}

resource "aws_secretsmanager_secret" "github_client_secret" {
  name = "example"
}

data "aws_secretsmanager_secret_version" "github_client_secret" {
  secret_id = aws_secretsmanager_secret.github_client_secret.id
}
