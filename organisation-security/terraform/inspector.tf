###########################
# Inspector in EU regions #
###########################

# Auto enable per region
resource "aws_inspector2_organization_configuration" "eu_west_2" {
  auto_enable {
    ec2    = true
    ecr    = true
    lambda = true
  }
}

resource "aws_inspector2_organization_configuration" "eu_west_1" {
  auto_enable {
    ec2    = true
    ecr    = true
    lambda = true
  }
}
