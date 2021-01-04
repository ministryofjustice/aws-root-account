#####################################
# Security Hub for AWS root account #
#####################################

# Enable SecurityHub and subscriptions within the default region for the root account
module "securityhub-default-region" {
  source = "./modules/securityhub"
}
