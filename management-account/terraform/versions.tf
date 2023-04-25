terraform {
  required_version = ">= 1.1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.61.0"
    }
    commonfate = {
      source  = "common-fate/commonfate"
      version = "1.2.0"
    }
  }
}

provider "commonfate" {
  aws_region         = "eu-west-2"
  governance_api_url = module.commonfate.governance_rest_api_endpoint
}
