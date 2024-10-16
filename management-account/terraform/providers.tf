# Default provider

provider "aws" {
  region = "eu-west-2"
}

# us-* providers

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us-east-2"
  region = "us-east-2"
}

provider "aws" {
  alias  = "us-west-1"
  region = "us-west-1"
}

provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
}

# af-* providers

provider "aws" {
  alias  = "af-south-1"
  region = "af-south-1"
}

# ap-* providers

provider "aws" {
  alias  = "ap-east-1"
  region = "ap-east-1"
}

provider "aws" {
  alias  = "ap-southeast-3"
  region = "ap-southeast-3"
}

provider "aws" {
  alias  = "ap-south-1"
  region = "ap-south-1"
}

provider "aws" {
  alias  = "ap-northeast-3"
  region = "ap-northeast-3"
}

provider "aws" {
  alias  = "ap-northeast-2"
  region = "ap-northeast-2"
}

provider "aws" {
  alias  = "ap-southeast-1"
  region = "ap-southeast-1"
}

provider "aws" {
  alias  = "ap-southeast-2"
  region = "ap-southeast-2"
}

provider "aws" {
  alias  = "ap-northeast-1"
  region = "ap-northeast-1"
}

# ca-* providers

provider "aws" {
  alias  = "ca-central-1"
  region = "ca-central-1"
}

# eu-* providers

provider "aws" {
  alias  = "eu-central-1"
  region = "eu-central-1"
}

provider "aws" {
  alias  = "eu-west-1"
  region = "eu-west-1"
}

provider "aws" {
  alias  = "eu-west-2"
  region = "eu-west-2"
}

provider "aws" {
  alias  = "eu-south-1"
  region = "eu-south-1"
}

provider "aws" {
  alias  = "eu-west-3"
  region = "eu-west-3"
}

provider "aws" {
  alias  = "eu-north-1"
  region = "eu-north-1"
}

# me-* providers

provider "aws" {
  alias  = "me-south-1"
  region = "me-south-1"
}

# sa-* providers

provider "aws" {
  alias  = "sa-east-1"
  region = "sa-east-1"
}
