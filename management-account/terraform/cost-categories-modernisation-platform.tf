resource "aws_ce_cost_category" "modernisation_platform" {
  name            = "Modernisation Platform"
  rule_version    = "CostCategoryExpression.v1"
  effective_start = "2025-02-01T00:00:00Z"

  rule {
    type  = "REGULAR"
    value = "Modernisation Platform"
    rule {
      dimension {
        key           = "LINKED_ACCOUNT"
        values        = data.aws_organizations_organizational_unit_descendant_accounts.modernisation_platform.accounts[*].id
        match_options = ["EQUALS"]
      }
    }
  }
}
