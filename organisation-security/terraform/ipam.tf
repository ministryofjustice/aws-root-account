###############################
# IPAM in EU regions #
###############################

locals {
  ipam_regions = [
    "eu-west-1",
    "eu-west-2",
    "eu-west-3",
    "eu-central-1"
  ]
}

# Create IPAM
resource "aws_vpc_ipam" "main" {
  description = "Multi Region IPAM"
  dynamic "operating_regions" {
    for_each = local.ipam_regions
    content {
      region_name = operating_regions.value
    }
  }
}

# Create Scopes
resource "aws_vpc_ipam_scope" "public" {
  ipam_id     = aws_vpc_ipam.main.id
  description = "Public Scope"
}

resource "aws_vpc_ipam_scope" "private" {
  ipam_id     = aws_vpc_ipam.main.id
  description = "Private Scope"
}

# Create pools

# Network Operations
resource "aws_vpc_ipam_pool" "network_operations_centre" {
  description    = "Network Operations Centre"
  address_family = "ipv4"
  ipam_scope_id  = aws_vpc_ipam_scope.public.id
  locale         = "eu-west-2"
  aws_service    = "ec2"
  tags           = { "owner" = "Networks" }
}

resource "aws_vpc_ipam_pool_cidr" "network_operations_centre" {
  ipam_pool_id = aws_vpc_ipam_pool.network_operations_centre.id
  cidr         = "51.149.252.0/24"
}

resource "aws_ram_resource_share" "network_operations_centre_byoip" {
  name                      = "network_operations_centre_byoip"
  allow_external_principals = false
  permission_arns = [
    "arn:aws:ram::aws:permission/AWSRAMDefaultPermissionsIpamPool"
  ]
}

resource "aws_ram_principal_association" "network_operations_centre_byoip" {
  principal          = local.workplace_tech_poc_development_account_id
  resource_share_arn = aws_ram_resource_share.network_operations_centre_byoip.arn
}

resource "aws_ram_resource_association" "network_operations_centre_byoip" {
  resource_arn       = aws_vpc_ipam_pool.network_operations_centre.arn
  resource_share_arn = aws_ram_resource_share.network_operations_centre_byoip.arn
}

resource "aws_ram_principal_association" "network_operations_centre_production_byoip" {
  principal          = local.moj_network_operations_centre_production_account_id
  resource_share_arn = aws_ram_resource_share.network_operations_centre_byoip.arn
}

resource "aws_ram_principal_association" "network_operations_centre_preproduction_byoip" {
  principal          = local.moj_network_operations_centre_preproduction_account_id
  resource_share_arn = aws_ram_resource_share.network_operations_centre_byoip.arn
}
