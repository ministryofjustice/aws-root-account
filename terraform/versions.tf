terraform {
  required_version = ">= 0.14.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.24.0"
    }
  }
}
