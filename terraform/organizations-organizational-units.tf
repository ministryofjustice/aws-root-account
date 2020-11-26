# Closed accounts
resource "aws_organizations_organizational_unit" "closed-accounts" {
  name      = "Closed accounts"
  parent_id = aws_organizations_organization.default.roots[0].id
}

resource "aws_organizations_organizational_unit" "closed-accounts-remove" {
  name      = "Remove"
  parent_id = aws_organizations_organizational_unit.closed-accounts.id
}

# OPG
resource "aws_organizations_organizational_unit" "opg" {
  name      = "OPG"
  parent_id = aws_organizations_organization.default.roots[0].id
}

# HMPPS
resource "aws_organizations_organizational_unit" "hmpps" {
  name      = "HMPPS"
  parent_id = aws_organizations_organization.default.roots[0].id
}

# YJB
resource "aws_organizations_organizational_unit" "yjb" {
  name      = "YJB"
  parent_id = aws_organizations_organization.default.roots[0].id
}

# LAA
resource "aws_organizations_organizational_unit" "laa" {
  name      = "LAA"
  parent_id = aws_organizations_organization.default.roots[0].id
}

# Central Digital
resource "aws_organizations_organizational_unit" "central-digital" {
  name      = "Central Digital"
  parent_id = aws_organizations_organization.default.roots[0].id
}

# Platforms & Architecture
resource "aws_organizations_organizational_unit" "platforms-and-architecture" {
  name      = "Platforms & Architecture"
  parent_id = aws_organizations_organization.default.roots[0].id
}

# Security Engineering
resource "aws_organizations_organizational_unit" "security-engineering" {
  name      = "Security Engineering"
  parent_id = aws_organizations_organization.default.roots[0].id
}

# Workplace Technology
resource "aws_organizations_organizational_unit" "workplace-technology" {
  name      = "Workplace Technology"
  parent_id = aws_organizations_organization.default.roots[0].id
}

# Analytics Platform
resource "aws_organizations_organizational_unit" "analytics-platform" {
  name      = "Analytics Platform"
  parent_id = aws_organizations_organization.default.roots[0].id
}

# Tactical Products
resource "aws_organizations_organizational_unit" "tactical-products" {
  name      = "Tactical Products"
  parent_id = aws_organizations_organization.default.roots[0].id
}

# CICA
resource "aws_organizations_organizational_unit" "cica" {
  name      = "CICA"
  parent_id = aws_organizations_organization.default.roots[0].id
}

# HMCTS
resource "aws_organizations_organizational_unit" "hmcts" {
  name      = "HMCTS"
  parent_id = aws_organizations_organization.default.roots[0].id
}
