resource "aws_ce_cost_category" "environment" {
  name         = "Environment"
  rule_version = "CostCategoryExpression.v1"

  rule {
    type  = "REGULAR"
    value = "Production"
    rule {
      tags {
        key           = "is-production"
        values        = ["true", "yes", "1", "prod", "PROD", "YES", "TRUE", "True", "Yes", "Prod"]
        match_options = ["CONTAINS"]
      }
    }
  }

  rule {
    type  = "REGULAR"
    value = "Non Production"
    rule {
      tags {
        key           = "is-production"
        values        = ["false", "no", "0", "NO", "FALSE", "False", "No"]
        match_options = ["CONTAINS"]
      }
    }
  }

  rule {
    type  = "REGULAR"
    value = "No is-production Tag"
    rule {
      tags {
        key           = "is-production"
        match_options = ["ABSENT"]
      }
    }
  }
}

import {
  to = aws_ce_cost_category.environment
  id = "arn:aws:ce::${data.aws_caller_identity.current.account_id}:costcategory/c97a38cf-82c0-4e6b-8649-91366543ac6f"
}
