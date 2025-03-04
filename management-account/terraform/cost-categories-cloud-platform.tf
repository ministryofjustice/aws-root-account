resource "aws_ce_cost_category" "cloud_platform" {
  name         = "Cloud Platform"
  rule_version = "CostCategoryExpression.v1"

  rule {
    type  = "REGULAR"
    value = "Cloud Platform"
    rule {
      dimension {
        key           = "LINKED_ACCOUNT"
        values        = data.aws_organizations_organizational_unit_descendant_accounts.cloud_platform.accounts[*].id
        match_options = ["EQUALS"]
      }
    }
  }
}

import {
  to = aws_ce_cost_category.cloud_platform
  id = "arn:aws:ce::${data.aws_caller_identity.current.account_id}:costcategory/3edadf90-8c24-467b-a80a-f5e96df1beb2"
}
