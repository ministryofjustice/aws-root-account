terraform {
  # `backend` blocks do not support variables, so the bucket name is hard-coded here
  backend "s3" {
    bucket  = "moj-aws-root-account-terraform-state"
    region  = "eu-west-2"
    key     = "organisation-security/terraform.tfstate"
    encrypt = true
  }
}
