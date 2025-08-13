resource "aws_ce_cost_category" "budgets" {
  name         = "Budgets"
  rule_version = "CostCategoryExpression.v1"

  rule {
    type  = "REGULAR"
    value = "OPG"

    rule {
      dimension {
        key           = "LINKED_ACCOUNT_NAME"
        match_options = ["CONTAINS"]
        values        = ["OPG", "opg", "LPA", "lpa"]
      }
    }
  }

  rule {
    type  = "REGULAR"
    value = "Electronic Monitoring"

    rule {
      dimension {
        key           = "LINKED_ACCOUNT_NAME"
        match_options = ["CONTAINS"]
        values        = ["Electronic Monitoring", "electronic-monitoring"]
      }
    }
  }

  rule {
    type  = "REGULAR"
    value = "Engineering"

    rule {
      not {
        or {
          dimension {
            key           = "LINKED_ACCOUNT_NAME"
            match_options = ["CONTAINS"]
            values        = ["OPG", "opg", "LPA", "lpa"]
          }
        }
        or {
          dimension {
            key           = "LINKED_ACCOUNT_NAME"
            match_options = ["CONTAINS"]
            values        = ["Electronic Monitoring", "electronic-monitoring*"]
          }
        }
      }
    }
  }
}
