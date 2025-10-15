###########################
# Inspector in EU and US-East regions #
###########################

# Data source to get all organization accounts
data "aws_organizations_organization" "current" {}

# Local value for test accounts
locals {
  # Test accounts for Inspector2 member association testing
  all_member_accounts = [
    "348456244381",
    "083957762049"
  ]
}

# Enable Inspector2 for all existing organization member accounts in new regions

resource "aws_inspector2_enabler" "eu_west_3" {
  provider       = aws.eu-west-3
  account_ids    = [data.aws_caller_identity.current.account_id]
  resource_types = ["EC2", "ECR", "LAMBDA"]
}

resource "aws_inspector2_enabler" "eu_central_1" {
  provider       = aws.eu-central-1
  account_ids    = [data.aws_caller_identity.current.account_id]
  resource_types = ["ECR", "EC2", "LAMBDA", "LAMBDA_CODE"]
}

resource "aws_inspector2_enabler" "us_east_1" {
  provider       = aws.us-east-1
  account_ids    = [data.aws_caller_identity.current.account_id]
  resource_types = ["ECR", "EC2", "LAMBDA", "LAMBDA_CODE"]
}

resource "aws_inspector2_enabler" "all_member_accounts_eu_west_3" {
  provider       = aws.organisation-security-eu-west-3
  account_ids    = local.all_member_accounts
  resource_types = ["EC2", "ECR", "LAMBDA"]
  depends_on     = [aws_inspector2_organization_configuration.eu_west_3]
}

resource "aws_inspector2_enabler" "all_member_accounts_eu_central_1" {
  provider       = aws.organisation-security-eu-central-1
  account_ids    = local.all_member_accounts
  resource_types = ["EC2", "ECR", "LAMBDA", "LAMBDA_CODE"]
  depends_on     = [aws_inspector2_organization_configuration.eu_central_1]
}

resource "aws_inspector2_enabler" "all_member_accounts_us_east_1" {
  provider       = aws.organisation-security-us-east-1
  account_ids    = local.all_member_accounts
  resource_types = ["EC2", "ECR", "LAMBDA", "LAMBDA_CODE"]
  depends_on     = [aws_inspector2_organization_configuration.us_east_1]
}

# Auto enable per region
resource "aws_inspector2_organization_configuration" "eu_west_2" {
  auto_enable {
    ec2         = true
    ecr         = true
    lambda      = true
    lambda_code = true
  }
}

resource "aws_inspector2_organization_configuration" "eu_west_1" {
  auto_enable {
    ec2         = true
    ecr         = true
    lambda      = true
    lambda_code = true
  }
}

resource "aws_inspector2_organization_configuration" "eu_west_3" {
  provider = aws.eu-west-3
  auto_enable {
    ec2    = true
    ecr    = true
    lambda = true
  }
}

resource "aws_inspector2_organization_configuration" "eu_central_1" {
  provider = aws.eu-central-1
  auto_enable {
    ec2         = true
    ecr         = true
    lambda      = true
    lambda_code = true
  }
}

resource "aws_inspector2_organization_configuration" "us_east_1" {
  provider = aws.us-east-1
  auto_enable {
    ec2         = true
    ecr         = true
    lambda      = true
    lambda_code = true
  }
}
