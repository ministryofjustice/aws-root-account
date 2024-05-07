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
