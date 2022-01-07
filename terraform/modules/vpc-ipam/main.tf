#############################
# VPC IP Address Management #
#############################

# Get current region
data "aws_region" "current" {
  provider = aws.root-account
}

# Get the organization management account ID
data "aws_caller_identity" "default" {
  provider = aws.root-account
}

# Get the delegated administrator account ID
data "aws_caller_identity" "delegated-administrator" {
  provider = aws.delegated-administrator
}

#####################################################
# VPC IP Address Management delegated administrator #
#####################################################

resource "aws_vpc_ipam_organization_admin_account" "default" {
  provider = aws.root-account

  delegated_admin_account_id = data.aws_caller_identity.delegated-administrator.account_id
}

#############################
# VPC IP Address Management #
#############################

# Note that this resource configures two default scopes: public and private

resource "aws_vpc_ipam" "default" {
  provider = aws.delegated-administrator

  dynamic "operating_regions" {
    for_each = var.operating_regions
    content {
      region_name = operating_regions.value
    }
  }

  depends_on = [
    aws_vpc_ipam_organization_admin_account.default
  ]
}
