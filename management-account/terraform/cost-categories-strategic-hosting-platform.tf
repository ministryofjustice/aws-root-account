resource "aws_ce_cost_category" "strategic_hosting_platform" {
  name          = "Strategic Hosting Platform"
  default_value = "Off Strategic Hosting Platform"
  rule_version  = "CostCategoryExpression.v1"

  rule {
    type  = "REGULAR"
    value = "Strategic Hosting Platform"

    rule {
      or {
        cost_category {
          key           = aws_ce_cost_category.cloud_platform.name
          values        = [aws_ce_cost_category.cloud_platform.name]
          match_options = ["EQUALS"]
        }
      }
      or {
        cost_category {
          key           = aws_ce_cost_category.modernisation_platform.name
          values        = [aws_ce_cost_category.modernisation_platform.name]
          match_options = ["EQUALS"]
        }
      }
    }
  }
}

import {
  to = aws_ce_cost_category.strategic_hosting_platform
  id = "arn:aws:ce::${data.aws_caller_identity.current.account_id}:costcategory/4ed468f9-f00c-46eb-b2c2-bb4b09d32016"
}
