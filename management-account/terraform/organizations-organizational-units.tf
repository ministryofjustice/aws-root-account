#######################
# Analytical Platform #
#######################
resource "aws_organizations_organizational_unit" "analytical_platform" {
  name      = "Analytical Platform"
  parent_id = aws_organizations_organization.default.roots[0].id
  tags      = {}
}

###################
# Central Digital #
###################
resource "aws_organizations_organizational_unit" "central_digital" {
  name      = "Central Digital"
  parent_id = aws_organizations_organization.default.roots[0].id
  tags      = {}
}

########
# CICA #
########
resource "aws_organizations_organizational_unit" "cica" {
  name      = "CICA"
  parent_id = aws_organizations_organization.default.roots[0].id
  tags      = {}
}

###################
# Closed accounts #
###################
resource "aws_organizations_organizational_unit" "closed_accounts" {
  name      = "Closed accounts"
  parent_id = aws_organizations_organization.default.roots[0].id
  tags      = {}
}

# Remove
resource "aws_organizations_organizational_unit" "closed_accounts_remove" {
  name      = "Remove"
  parent_id = aws_organizations_organizational_unit.closed_accounts.id
  tags      = {}
}

#########
# HMCTS #
#########
resource "aws_organizations_organizational_unit" "hmcts" {
  name      = "HMCTS"
  parent_id = aws_organizations_organization.default.roots[0].id
  tags      = {}
}

#########
# HMPPS #
#########
resource "aws_organizations_organizational_unit" "hmpps" {
  name      = "HMPPS"
  parent_id = aws_organizations_organization.default.roots[0].id
  tags      = {}
}

# Community Rehabilitation
resource "aws_organizations_organizational_unit" "hmpps_community_rehabilitation" {
  name      = "Community Rehabilitation"
  parent_id = aws_organizations_organizational_unit.hmpps.id
  tags      = {}
}

# Delius
resource "aws_organizations_organizational_unit" "hmpps_delius" {
  name      = "Delius"
  parent_id = aws_organizations_organizational_unit.hmpps.id
  tags      = {}
}

# Electronic Monitoring
resource "aws_organizations_organizational_unit" "hmpps_electronic_monitoring" {
  name      = "Electronic Monitoring"
  parent_id = aws_organizations_organizational_unit.hmpps.id
  tags      = {}
}

# Acquisitive Crime
resource "aws_organizations_organizational_unit" "hmpps_electronic_monitoring_acquisitive_crime" {
  name      = "Acquisitive Crime"
  parent_id = aws_organizations_organizational_unit.hmpps_electronic_monitoring.id
  tags      = {}
}

# Case Management
resource "aws_organizations_organizational_unit" "hmpps_electronic_monitoring_case_management" {
  name      = "Case Management"
  parent_id = aws_organizations_organizational_unit.hmpps_electronic_monitoring.id
  tags      = {}
}

# VCMS
resource "aws_organizations_organizational_unit" "hmpps_vcms" {
  name      = "VCMS"
  parent_id = aws_organizations_organizational_unit.hmpps.id
  tags      = {}
}

#######
# LAA #
#######
resource "aws_organizations_organizational_unit" "laa" {
  name      = "LAA"
  parent_id = aws_organizations_organization.default.roots[0].id
  tags      = {}
}

#######
# OPG #
#######
resource "aws_organizations_organizational_unit" "opg" {
  name      = "OPG"
  parent_id = aws_organizations_organization.default.roots[0].id
  tags      = {}
}

# DigiCop
resource "aws_organizations_organizational_unit" "opg_digicop" {
  name      = "DigiCop"
  parent_id = aws_organizations_organizational_unit.opg.id
  tags      = {}
}

# DigiDeps
resource "aws_organizations_organizational_unit" "opg_digideps" {
  name      = "DigiDeps"
  parent_id = aws_organizations_organizational_unit.opg.id
  tags      = {}
}

# LPA Refunds
resource "aws_organizations_organizational_unit" "opg_lpa_refunds" {
  name      = "LPA Refunds"
  parent_id = aws_organizations_organizational_unit.opg.id
  tags      = {}
}

# Make An LPA
resource "aws_organizations_organizational_unit" "opg_make_an_lpa" {
  name      = "Make An LPA"
  parent_id = aws_organizations_organizational_unit.opg.id
  tags      = {}
}

# Modernising LPA
resource "aws_organizations_organizational_unit" "opg_modernising_lpa" {
  name      = "Modernising LPA"
  parent_id = aws_organizations_organizational_unit.opg.id
  tags      = {}
}

# Sirius
resource "aws_organizations_organizational_unit" "opg_sirius" {
  name      = "Sirius"
  parent_id = aws_organizations_organizational_unit.opg.id
  tags      = {}
}

# Use My LPA
resource "aws_organizations_organizational_unit" "opg_use_my_lpa" {
  name      = "Use My LPA"
  parent_id = aws_organizations_organizational_unit.opg.id
  tags      = {}
}

###########################
# Organisation Management #
###########################
resource "aws_organizations_organizational_unit" "organisation_management" {
  name      = "Organisation Management"
  parent_id = aws_organizations_organization.default.roots[0].id
  tags      = {}
}

############################
# Platforms & Architecture #
############################
resource "aws_organizations_organizational_unit" "platforms_and_architecture" {
  name      = "Platforms & Architecture"
  parent_id = aws_organizations_organization.default.roots[0].id
  tags      = {}
}

# Cloud Platform
resource "aws_organizations_organizational_unit" "platforms_and_architecture_cloud_platform" {
  name      = "Cloud Platform"
  parent_id = aws_organizations_organizational_unit.platforms_and_architecture.id
  tags      = {}
}

# Modernisation Platform
resource "aws_organizations_organizational_unit" "platforms_and_architecture_modernisation_platform" {
  name      = "Modernisation Platform"
  parent_id = aws_organizations_organizational_unit.platforms_and_architecture.id
  tags      = {}
}

########################
# Security Engineering #
########################
resource "aws_organizations_organizational_unit" "security_engineering" {
  name      = "Security Engineering"
  parent_id = aws_organizations_organization.default.roots[0].id
  tags      = {}
}

#####################
# Tactical Products #
#####################
resource "aws_organizations_organizational_unit" "tactical_products" {
  name      = "Tactical Products"
  parent_id = aws_organizations_organization.default.roots[0].id
  tags      = {}
}

########################
# Workplace Technology #
########################
resource "aws_organizations_organizational_unit" "workplace_technology" {
  name      = "Workplace Technology"
  parent_id = aws_organizations_organization.default.roots[0].id
  tags      = {}
}

#######
# YJB #
#######
resource "aws_organizations_organizational_unit" "yjb" {
  name      = "YJB"
  parent_id = aws_organizations_organization.default.roots[0].id
  tags      = {}
}