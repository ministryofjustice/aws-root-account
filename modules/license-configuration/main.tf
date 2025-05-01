resource "aws_licensemanager_license_configuration" "default" {
  name                     = var.name
  description              = var.description
  license_count            = var.license_count
  license_count_hard_limit = var.license_count_hard_limit
  license_counting_type    = var.license_counting_type
}

# RAM share licence configurations
resource "aws_ram_resource_share" "default" {
  name                      = var.name
  allow_external_principals = false
}

resource "aws_ram_resource_association" "default" {
  resource_arn       = aws_licensemanager_license_configuration.default.arn
  resource_share_arn = aws_ram_resource_share.default.arn
}

resource "aws_ram_principal_association" "default" {
  principal          = var.principal
  resource_share_arn = aws_ram_resource_share.default.arn
}


