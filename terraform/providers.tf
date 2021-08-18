##################################
# MOJ AWS root account providers #
##################################

# Default provider (as everything should be in eu-west-2 by default)
provider "aws" {
  region = "eu-west-2"
}

# us-east-1
provider "aws" {
  region = "us-east-1"
  alias  = "aws-root-account-us-east-1"
}

# us-east-2
provider "aws" {
  region = "us-east-2"
  alias  = "aws-root-account-us-east-2"
}

# us-west-1
provider "aws" {
  region = "us-west-1"
  alias  = "aws-root-account-us-west-1"
}

# us-west-2
provider "aws" {
  region = "us-west-2"
  alias  = "aws-root-account-us-west-2"
}

# ap-south-1
provider "aws" {
  region = "ap-south-1"
  alias  = "aws-root-account-ap-south-1"
}

# ap-northeast-3
provider "aws" {
  region = "ap-northeast-3"
  alias  = "aws-root-account-ap-northeast-3"
}

# ap-northeast-2
provider "aws" {
  region = "ap-northeast-2"
  alias  = "aws-root-account-ap-northeast-2"
}

# ap-southeast-1
provider "aws" {
  region = "ap-southeast-1"
  alias  = "aws-root-account-ap-southeast-1"
}

# ap-southeast-2
provider "aws" {
  region = "ap-southeast-2"
  alias  = "aws-root-account-ap-southeast-2"
}

# ap-northeast-1
provider "aws" {
  region = "ap-northeast-1"
  alias  = "aws-root-account-ap-northeast-1"
}

# ca-central-1
provider "aws" {
  region = "ca-central-1"
  alias  = "aws-root-account-ca-central-1"
}

# eu-central-1
provider "aws" {
  region = "eu-central-1"
  alias  = "aws-root-account-eu-central-1"
}

# eu-west-1
provider "aws" {
  region = "eu-west-1"
  alias  = "aws-root-account-eu-west-1"
}

# eu-west-2
provider "aws" {
  region = "eu-west-2"
  alias  = "aws-root-account-eu-west-2"
}

# eu-west-3
provider "aws" {
  region = "eu-west-3"
  alias  = "aws-root-account-eu-west-3"
}

# eu-north-1
provider "aws" {
  region = "eu-north-1"
  alias  = "aws-root-account-eu-north-1"
}

# sa-east-1
provider "aws" {
  region = "sa-east-1"
  alias  = "aws-root-account-sa-east-1"
}
