# Provider for the Modernisation Platform, to get account IDs managed by the Modernisation Platform
provider "aws" {
  alias  = "modernisation-platform"
  region = "eu-west-2"

  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.modernisation-platform.id}:role/OrganizationAccountAccessRole"
  }
}
