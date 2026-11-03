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

data "aws_organizations_organizational_unit_descendant_accounts" "opg" {
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

data "aws_region" "current" {}

# WizAccess-Role, deployed into this account by the Wiz StackSet (wiz.tf)
data "aws_iam_role" "wiz" {
  count = local.wiz_enabled ? 1 : 0
  name  = module.wiz_stackset[0].wiz_role_name
}
