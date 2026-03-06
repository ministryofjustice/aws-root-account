###########################
# Inspector in EU and US-East regions #
###########################

# Data source to get all organization accounts
data "aws_organizations_organization" "current" {}

# Local value to chunk accounts into batches of 100 (AWS API limit)
locals {
  all_member_accounts = [
    for account in data.aws_organizations_organization.current.accounts :
    account.id if account.id != local.root_account_id && account.id != data.aws_caller_identity.current.account_id &&
    account.status == "ACTIVE"
  ]

  # Split accounts into chunks of 100
  account_chunks = [
    for i in range(0, length(local.all_member_accounts), 100) :
    slice(local.all_member_accounts, i, min(i + 100, length(local.all_member_accounts)))
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
  for_each       = { for idx, chunk in local.account_chunks : idx => chunk }
  provider       = aws.eu-west-3
  account_ids    = each.value
  resource_types = ["EC2", "ECR", "LAMBDA"]
  depends_on     = [aws_inspector2_member_association.eu_west_3]
}

resource "aws_inspector2_enabler" "all_member_accounts_eu_central_1" {
  for_each       = { for idx, chunk in local.account_chunks : idx => chunk }
  provider       = aws.eu-central-1
  account_ids    = each.value
  resource_types = ["EC2", "ECR", "LAMBDA", "LAMBDA_CODE"]
  depends_on     = [aws_inspector2_member_association.eu_central_1]
}

resource "aws_inspector2_enabler" "all_member_accounts_us_east_1" {
  for_each       = { for idx, chunk in local.account_chunks : idx => chunk }
  provider       = aws.us-east-1
  account_ids    = each.value
  resource_types = ["EC2", "ECR", "LAMBDA", "LAMBDA_CODE"]
  depends_on     = [aws_inspector2_member_association.us_east_1]
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
    ec2         = true
    ecr         = true
    lambda      = true
    lambda_code = true
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

# Member associations for explicit association with delegated admin account
resource "aws_inspector2_member_association" "us_east_1" {
  for_each   = toset(local.all_member_accounts)
  provider   = aws.us-east-1
  account_id = each.value
}

resource "aws_inspector2_member_association" "eu_central_1" {
  for_each   = toset(local.all_member_accounts)
  provider   = aws.eu-central-1
  account_id = each.value
}

resource "aws_inspector2_member_association" "eu_west_3" {
  for_each   = toset(local.all_member_accounts)
  provider   = aws.eu-west-3
  account_id = each.value
}

