#############################
# VPC IP Address Management #
#############################

module "vpc-ipam" {
  source = "./modules/vpc-ipam"

  providers = {
    aws.root-account            = aws.aws-root-account-eu-west-2
    aws.delegated-administrator = aws.organisation-security-eu-west-2
  }

  depends_on = [aws_organizations_organization.default]
}
