terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
      configuration_aliases = [
        aws.root_account,
        aws.delegated_administrator
      ]
    }
  }
  required_version = ">= 1.0"
}
