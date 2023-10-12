data "aws_caller_identity" "current" {}

data "aws_organizations_organizational_units" "organizational_units" {
  parent_id = local.organizations_organization.roots[0].id
}

data "aws_organizations_organizational_units" "platforms_and_architecture" {
  parent_id = local.ou_platforms_and_architecture_id
}

data "aws_organizations_organizational_units" "modernisation_platform" {
  parent_id = local.ou_modernisation_platform_id
}

data "aws_organizations_organizational_units" "modernisation_platform_core" {
  parent_id = local.ou_modernisation_platform_core_id
}

data "aws_organizations_organizational_units" "modernisation_platform_member" {
  parent_id = local.ou_modernisation_platform_member_id
}

data "aws_organizations_organizational_units" "opg" {
  parent_id = local.ou_opg
}

data "terraform_remote_state" "management_account" {
  backend = "s3"
  config = {
    bucket = "moj-aws-root-account-terraform-state"
    key    = "management-account/terraform.tfstate"
    region = "eu-west-2"
  }
}
