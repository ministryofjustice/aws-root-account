terraform {
  # `backend` blocks do not support variables, so the bucket name is hard-coded here, although created in s3.tf
  backend "s3" {
    bucket  = "moj-aws-root-account-terraform-state"
    region  = "eu-west-2"
    key     = "root/terraform.tfstate"
    encrypt = true
  }
}
