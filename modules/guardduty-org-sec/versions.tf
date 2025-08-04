terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.18.0"
      configuration_aliases = [
        aws.delegated_administrator
      ]
    }
  }
  required_version = ">= 0.15.0"
}
