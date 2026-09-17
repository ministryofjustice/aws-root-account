# Data source per business unit to provide parent account ID for all descendant accounts
data "aws_organizations_organizational_unit_descendant_accounts" "modernisation_platform" {
  parent_id = aws_organizations_organizational_unit.platforms_and_architecture_modernisation_platform.id
}

data "aws_organizations_organizational_unit_descendant_accounts" "cloud_platform" {
  parent_id = aws_organizations_organizational_unit.platforms_and_architecture_cloud_platform.id
}

data "aws_organizations_organizational_unit_descendant_accounts" "central_digital" {
  parent_id = aws_organizations_organizational_unit.central_digital.id
}

data "aws_organizations_organizational_unit_descendant_accounts" "hmpps" {
  parent_id = aws_organizations_organizational_unit.hmpps.id
}

data "aws_organizations_organizational_unit_descendant_accounts" "laa" {
  parent_id = aws_organizations_organizational_unit.laa.id
}

data "aws_organizations_organizational_unit_descendant_accounts" "opg" {
  parent_id = aws_organizations_organizational_unit.opg.id
}

data "aws_organizations_organizational_unit_descendant_accounts" "cica" {
  parent_id = aws_organizations_organizational_unit.cica.id
}

data "aws_organizations_organizational_unit_descendant_accounts" "hmcts" {
  parent_id = aws_organizations_organizational_unit.hmcts.id
}

data "aws_organizations_organizational_unit_descendant_accounts" "technology_services" {
  parent_id = aws_organizations_organizational_unit.technology_services.id
}

#Fetch all AWS Organization accounts and their metadata (IDs, names, tags)
# These are used by cost category rules to categorize spending
data "awscc_organizations_accounts" "all" {}

data "awscc_organizations_account" "all" {
  for_each = data.awscc_organizations_accounts.all.ids
  id       = each.value
}
