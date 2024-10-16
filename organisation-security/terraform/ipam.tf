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
  ipam_pools = {
    modernisation_platform = [
      "modernisation-platform-live-data",
      "modernisation-platform-non-live-data"
    ]
  }
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

# Modernisation Platform
resource "aws_vpc_ipam_pool" "modernisation_platform_private" {
  for_each       = toset(local.ipam_pools.modernisation_platform)
  address_family = "ipv4"
  description    = "Modernisation Platform"
  ipam_scope_id  = aws_vpc_ipam.main.private_default_scope_id
  tags = {
    "owner" = "Modernisation Platform",
    "name"  = each.value
  }
}

resource "aws_ram_resource_share" "modernisation_platform_private" {
  name                      = "modernisation_platform_private"
  allow_external_principals = false
  permission_arns = [
    "arn:aws:ram::aws:permission/AWSRAMDefaultPermissionsIpamPool"
  ]
}

resource "aws_ram_resource_association" "modernisation_platform_private" {
  for_each           = toset(local.ipam_pools.modernisation_platform)
  resource_arn       = aws_vpc_ipam_pool.modernisation_platform_private[each.key].arn
  resource_share_arn = aws_ram_resource_share.modernisation_platform_private.arn
}

resource "aws_ram_principal_association" "modernisation_platform_private" {
  principal          = local.ou_modernisation_platform_core_arn
  resource_share_arn = aws_ram_resource_share.modernisation_platform_private.arn
}
