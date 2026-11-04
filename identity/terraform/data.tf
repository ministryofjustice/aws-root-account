data "terraform_remote_state" "management_account" {
  backend = "s3"
  config = {
    bucket = "moj-aws-root-account-terraform-state"
    region = "eu-west-2"
    key    = "management-account/terraform.tfstate"
  }
}
