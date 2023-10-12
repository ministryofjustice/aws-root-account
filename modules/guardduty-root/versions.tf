terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.27.0"
      configuration_aliases = [
        aws.root_account,
        aws.delegated_administrator
      ]
    }
  }
  required_version = ">= 0.15.0"
}
