data "aws_organizations_organizational_unit_descendant_accounts" "modernisation_platform" {
  parent_id = aws_organizations_organizational_unit.platforms_and_architecture_modernisation_platform.id
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

data "aws_organizations_organizational_unit_descendant_accounts" "yjb" {
  parent_id = aws_organizations_organizational_unit.yjb.id
}
