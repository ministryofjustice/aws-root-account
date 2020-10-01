terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    auth0 = {
      source = "alexkappa/auth0"
      version = "0.15.2"
    }
  }
}
