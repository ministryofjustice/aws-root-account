# AWS account data
data "aws_caller_identity" "current" {}

# TLS certificate data
data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}
