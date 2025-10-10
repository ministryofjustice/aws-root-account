###########################
# Inspector in EU and US-East regions #
###########################

# Enable Inspector in each region where it's not currently active
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
