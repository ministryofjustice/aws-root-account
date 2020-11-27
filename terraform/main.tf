terraform {
  # `backend` blocks do not support variables, so the bucket name is hard-coded here, although created in s3.tf
  backend "s3" {
    bucket  = "moj-aws-root-account-terraform-state"
    region  = "eu-west-2"
    key     = "root/terraform.tfstate"
    encrypt = true
  }
}

# Default provider, as everything should be in eu-west-2 by default
provider "aws" {
  region = "eu-west-2"
}

# eu-west-1 provider, for anything that needs to be in eu-west-2
provider "aws" {
  alias  = "aws-root-account-eu-west-1"
  region = "eu-west-1"
}
