# Note that enrolling accounts is currently manual, as there is no Terraform resource for it.

###########################
# Inspector in EU regions #
###########################
module "inspector-eu-west-2" {
  source = "./modules/inspector"

  providers = {
    aws.root-account            = aws.aws-root-account-eu-west-2
    aws.delegated-administrator = aws.organisation-security-eu-west-2
  }

  depends_on = [aws_organizations_organization.default]
}

module "inspector-eu-west-1" {
  source = "./modules/inspector"

  providers = {
    aws.root-account            = aws.aws-root-account-eu-west-1
    aws.delegated-administrator = aws.organisation-security-eu-west-1
  }

  depends_on = [aws_organizations_organization.default]
}
