###########################
# Inspector in EU and US-East regions #
###########################

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
  auto_enable {
    ec2         = true
    ecr         = true
    lambda      = true
    lambda_code = false
  }
}

resource "aws_inspector2_organization_configuration" "eu_central_1" {
  auto_enable {
    ec2         = true
    ecr         = true
    lambda      = true
    lambda_code = true
  }
}

resource "aws_inspector2_organization_configuration" "us_east_1" {
  auto_enable {
    ec2         = true
    ecr         = true
    lambda      = true
    lambda_code = true
  }
}
