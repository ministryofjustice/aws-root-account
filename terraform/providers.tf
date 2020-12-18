# Providers for the MOJ AWS root account
## Default provider, as everything should be in eu-west-2 by default
provider "aws" {
  region = "eu-west-2"
}

## eu-west-1 provider, for anything that needs to be in eu-west-2
provider "aws" {
  alias  = "aws-root-account-eu-west-1"
  region = "eu-west-1"
}
