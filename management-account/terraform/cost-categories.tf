data "aws_organizations_organizational_unit_descendant_accounts" "modernisation_platform" {
  parent_id = aws_organizations_organizational_unit.platforms_and_architecture_modernisation_platform.id
}

resource "aws_ce_cost_category" "modernisation_platform" {
  name         = "Modernisation Platform"
  rule_version = "CostCategoryExpression.v1"
  rule {
    rule {
      dimension {
        key           = "LINKED_ACCOUNT"
        values        = data.aws_organizations_organizational_unit_descendant_accounts.modernisation_platform.accounts[*].id
        match_options = ["EQUALS"]
      }
    }
  }
}

