# Organisation Management accounts
resource "aws_organizations_organizational_unit" "organisation-management" {
  name      = "Organisation Management"
  parent_id = aws_organizations_organization.default.roots[0].id
}

resource "aws_organizations_policy_attachment" "organisation-management-ou-full-access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.organisation-management.id
}

# Closed accounts
resource "aws_organizations_organizational_unit" "closed-accounts" {
  name      = "Closed accounts"
  parent_id = aws_organizations_organization.default.roots[0].id
}

resource "aws_organizations_policy_attachment" "closed-accounts-ou-full-access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.closed-accounts.id
}

resource "aws_organizations_organizational_unit" "closed-accounts-remove" {
  name      = "Remove"
  parent_id = aws_organizations_organizational_unit.closed-accounts.id
}

resource "aws_organizations_policy_attachment" "closed-accounts-remove-ou-full-access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.closed-accounts-remove.id
}

# OPG
resource "aws_organizations_organizational_unit" "opg" {
  name      = "OPG"
  parent_id = aws_organizations_organization.default.roots[0].id
}

resource "aws_organizations_policy_attachment" "opg-ou-full-access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.opg.id
}

resource "aws_organizations_organizational_unit" "opg-lpa-refunds" {
  name      = "LPA Refunds"
  parent_id = aws_organizations_organizational_unit.opg.id
}

resource "aws_organizations_policy_attachment" "opg-lpa-refunds-ou-full-access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.opg-lpa-refunds.id
}

resource "aws_organizations_organizational_unit" "opg-sirius" {
  name      = "Sirius"
  parent_id = aws_organizations_organizational_unit.opg.id
}

resource "aws_organizations_policy_attachment" "opg-sirius-ou-full-access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.opg-sirius.id
}

resource "aws_organizations_organizational_unit" "opg-digideps" {
  name      = "DigiDeps"
  parent_id = aws_organizations_organizational_unit.opg.id
}

resource "aws_organizations_policy_attachment" "opg-digideps-ou-full-access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.opg-digideps.id
}

resource "aws_organizations_organizational_unit" "opg-make-an-lpa" {
  name      = "Make An LPA"
  parent_id = aws_organizations_organizational_unit.opg.id
}

resource "aws_organizations_policy_attachment" "opg-make-an-lpa-ou-full-access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.opg-make-an-lpa.id
}

resource "aws_organizations_organizational_unit" "opg-digicop" {
  name      = "DigiCop"
  parent_id = aws_organizations_organizational_unit.opg.id
}

resource "aws_organizations_policy_attachment" "opg-digicop-ou-full-access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.opg-digicop.id
}

resource "aws_organizations_organizational_unit" "opg-use-my-lpa" {
  name      = "Use My LPA"
  parent_id = aws_organizations_organizational_unit.opg.id
}

resource "aws_organizations_policy_attachment" "opg-use-my-lpa-ou-full-access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.opg-use-my-lpa.id
}

# HMPPS
resource "aws_organizations_organizational_unit" "hmpps" {
  name      = "HMPPS"
  parent_id = aws_organizations_organization.default.roots[0].id
}

resource "aws_organizations_policy_attachment" "hmpps-ou-full-access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.hmpps.id
}

resource "aws_organizations_organizational_unit" "hmpps-vcms" {
  name      = "VCMS"
  parent_id = aws_organizations_organizational_unit.hmpps.id
}

resource "aws_organizations_policy_attachment" "hmpps-vcms-ou-full-access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.hmpps-vcms.id
}

resource "aws_organizations_organizational_unit" "hmpps-delius" {
  name      = "Delius"
  parent_id = aws_organizations_organizational_unit.hmpps.id
}

resource "aws_organizations_policy_attachment" "hmpps-delius-ou-full-access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.hmpps-delius.id
}

resource "aws_organizations_organizational_unit" "hmpps-electronic-monitoring" {
  name      = "Electronic Monitoring"
  parent_id = aws_organizations_organizational_unit.hmpps.id
}

resource "aws_organizations_policy_attachment" "hmpps-electronic-monitoring-ou-full-access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.hmpps-electronic-monitoring.id
}

resource "aws_organizations_organizational_unit" "hmpps-electronic-monitoring-acquisitive-crime" {
  name      = "Acquisitive Crime"
  parent_id = aws_organizations_organizational_unit.hmpps-electronic-monitoring
}

# Enrol all accounts within the Acquisitive Crime OU (current and future) to the restricted regions policy
resource "aws_organizations_policy_attachment" "hmpps-electronic-monitoring-acquisitive-crime-ou-restricted-regions" {
  policy_id = aws_organizations_policy.deny-non-eu-non-us-east-1-operations.id
  target_id = aws_organizations_organizational_unit.hmpps-electronic-monitoring-acquisitive-crime.id
}

# YJB
resource "aws_organizations_organizational_unit" "yjb" {
  name      = "YJB"
  parent_id = aws_organizations_organization.default.roots[0].id
}

resource "aws_organizations_policy_attachment" "yjb-ou-full-access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.yjb.id
}

# LAA
resource "aws_organizations_organizational_unit" "laa" {
  name      = "LAA"
  parent_id = aws_organizations_organization.default.roots[0].id
}

resource "aws_organizations_policy_attachment" "laa-ou-full-access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.laa.id
}

resource "aws_organizations_policy_attachment" "laa" {
  policy_id = aws_organizations_policy.deny-cloudtrail-delete-stop-update-policy.id
  target_id = aws_organizations_organizational_unit.laa.id
}

# Central Digital
resource "aws_organizations_organizational_unit" "central-digital" {
  name      = "Central Digital"
  parent_id = aws_organizations_organization.default.roots[0].id
}

resource "aws_organizations_policy_attachment" "central-digital-ou-full-access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.central-digital.id
}

# Platforms & Architecture
resource "aws_organizations_organizational_unit" "platforms-and-architecture" {
  name      = "Platforms & Architecture"
  parent_id = aws_organizations_organization.default.roots[0].id
}

resource "aws_organizations_policy_attachment" "platforms-and-architecture-ou-full-access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.platforms-and-architecture.id
}

resource "aws_organizations_organizational_unit" "platforms-and-architecture-cloud-platform" {
  name      = "Cloud Platform"
  parent_id = aws_organizations_organizational_unit.platforms-and-architecture.id
}

resource "aws_organizations_policy_attachment" "platforms-and-architecture-cloud-platform-ou-full-access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.platforms-and-architecture-cloud-platform.id
}

# There are more OUs within the Modernisation Platform, but they are managed elsewhere
# See: https://github.com/ministryofjustice/modernisation-platform
resource "aws_organizations_organizational_unit" "platforms-and-architecture-modernisation-platform" {
  name      = "Modernisation Platform"
  parent_id = aws_organizations_organizational_unit.platforms-and-architecture.id
}

resource "aws_organizations_policy_attachment" "platforms-and-architecture-modernisation-platform-ou-full-access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.platforms-and-architecture-modernisation-platform.id
}

# Enrol all accounts within the Modernisation Platform OU (current and future) to the restricted regions policy
resource "aws_organizations_policy_attachment" "platforms-and-architecture-modernisation-platform-ou-restricted-regions" {
  policy_id = aws_organizations_policy.deny-non-eu-non-us-east-1-operations.id
  target_id = aws_organizations_organizational_unit.platforms-and-architecture-modernisation-platform.id
}

# Security Engineering
resource "aws_organizations_organizational_unit" "security-engineering" {
  name      = "Security Engineering"
  parent_id = aws_organizations_organization.default.roots[0].id
}

resource "aws_organizations_policy_attachment" "security-engineering-ou-full-access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.security-engineering.id
}

# Workplace Technology
resource "aws_organizations_organizational_unit" "workplace-technology" {
  name      = "Workplace Technology"
  parent_id = aws_organizations_organization.default.roots[0].id
}

resource "aws_organizations_policy_attachment" "workplace-technology-ou-full-access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.workplace-technology.id
}

# Analytics Platform
resource "aws_organizations_organizational_unit" "analytics-platform" {
  name      = "Analytics Platform"
  parent_id = aws_organizations_organization.default.roots[0].id
}

resource "aws_organizations_policy_attachment" "analytics-platform-ou-full-access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.analytics-platform.id
}

# Tactical Products
resource "aws_organizations_organizational_unit" "tactical-products" {
  name      = "Tactical Products"
  parent_id = aws_organizations_organization.default.roots[0].id
}

resource "aws_organizations_policy_attachment" "tactical-products-ou-full-access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.tactical-products.id
}

# CICA
resource "aws_organizations_organizational_unit" "cica" {
  name      = "CICA"
  parent_id = aws_organizations_organization.default.roots[0].id
}

resource "aws_organizations_policy_attachment" "cica-ou-full-access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.cica.id
}

# HMCTS
resource "aws_organizations_organizational_unit" "hmcts" {
  name      = "HMCTS"
  parent_id = aws_organizations_organization.default.roots[0].id
}

resource "aws_organizations_policy_attachment" "hmcts-ou-full-access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.hmcts.id
}
