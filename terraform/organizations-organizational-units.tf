# These resources (`aws_organizations_organizational_unit`) are now managed in management-account/terraform/organizations-organizational-units.tf
# They have been left here whilst the other resources are moved (as there is a dependency on them)

# Organisation Management accounts
resource "aws_organizations_organizational_unit" "organisation-management" {
  name      = "Organisation Management"
  parent_id = aws_organizations_organization.default.roots[0].id
}

# Platforms & Architecture
resource "aws_organizations_organizational_unit" "platforms-and-architecture" {
  name      = "Platforms & Architecture"
  parent_id = aws_organizations_organization.default.roots[0].id
}

# There are more OUs within the Modernisation Platform, but they are managed elsewhere
# See: https://github.com/ministryofjustice/modernisation-platform
resource "aws_organizations_organizational_unit" "platforms-and-architecture-modernisation-platform" {
  name      = "Modernisation Platform"
  parent_id = aws_organizations_organizational_unit.platforms-and-architecture.id
}

# Security Engineering
resource "aws_organizations_organizational_unit" "security-engineering" {
  name      = "Security Engineering"
  parent_id = aws_organizations_organization.default.roots[0].id
}
