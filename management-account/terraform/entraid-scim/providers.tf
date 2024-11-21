# State config
terraform {
  # `backend` blocks do not support variables, so the bucket name is hard-coded here
  backend "s3" {
    bucket  = "moj-aws-root-account-terraform-state"
    region  = "eu-west-2"
    key     = "management-account/entraid-scim/terraform.tfstate"
    encrypt = true
  }
}

# Default provider
provider "aws" {
  region = "eu-west-2"
}

# Azure provider
provider "azuread" {
  tenant_id     = jsondecode(data.aws_secretsmanager_secret_version.azure_aws_connectivity_details.secret_string)["AZURE_TENANT_ID"]
  client_id     = jsondecode(data.aws_secretsmanager_secret_version.azure_aws_connectivity_details.secret_string)["AZURE_CLIENT_ID"]
  client_secret = jsondecode(data.aws_secretsmanager_secret_version.azure_aws_connectivity_details.secret_string)["AZURE_CLIENT_SECRET"]
}