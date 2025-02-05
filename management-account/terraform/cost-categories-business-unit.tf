locals {
  business_units = {
    "CICA" = {
      businss_unit_tag_values = ["CICA", "cica"]
      aws_accounts            = data.aws_organizations_organizational_unit_descendant_accounts.cica.accounts[*].id
    },
    "HMCTS" = {
      businss_unit_tag_values = ["HMCTS"]
      aws_accounts            = data.aws_organizations_organizational_unit_descendant_accounts.hmcts.accounts[*].id
    },
    "HMPPS" = {
      businss_unit_tag_values = ["HMPPS", "hmpps"]
      aws_accounts            = data.aws_organizations_organizational_unit_descendant_accounts.hmpps.accounts[*].id
    },
    "HQ" = {
      businss_unit_tag_values = ["HQ", "MoJO-HQ", "hq"]
      aws_accounts            = []
    },
    "LAA" = {
      businss_unit_tag_values = ["LAA", "laa", "legal-aid-agency"]
      aws_accounts            = data.aws_organizations_organizational_unit_descendant_accounts.laa.accounts[*].id
    },
    "OPG" = {
      businss_unit_tag_values = ["OPG", "opg"]
      aws_accounts            = data.aws_organizations_organizational_unit_descendant_accounts.opg.accounts[*].id
    },
    "Platforms" = {
      businss_unit_tag_values = ["Platform", "Platforms", "platforms"]
      aws_accounts            = []
    },
    "YJB" = {
      businss_unit_tag_values = ["YJB", "yjb"]
      aws_accounts            = data.aws_organizations_organizational_unit_descendant_accounts.yjb.accounts[*].id
    },
  }
}

import {
  to = aws_ce_cost_category.business_unit
  id = "arn:aws:ce::${data.aws_caller_identity.current.account_id}:costcategory/c52f8445-757f-404e-bb15-5009ba09fe15"
}

resource "aws_ce_cost_category" "business_unit" {
  name            = "Business Unit"
  default_value   = "Uncategorised Business Unit"
  rule_version    = "CostCategoryExpression.v1"
  effective_start = "2024-02-01T00:00:00Z"

  # Rule 1: Prioritize the `business-unit` Tag for Allocating Cost
  dynamic "rule" {
    for_each = local.business_units
    content {
      type  = "REGULAR"
      value = rule.key

      rule {
        tags {
          key           = "business-unit"
          values        = rule.value.businss_unit_tag_values
          match_options = ["EQUALS"]
        }
      }
    }
  }

  # Rule 2: If No `business-unit` Tag, Assign Cost Based on the Organizational Unit
  dynamic "rule" {
    for_each = local.business_units
    content {
      value = rule.key

      rule {
        dimension {
          key           = "LINKED_ACCOUNT"
          values        = rule.value.aws_accounts
          match_options = ["EQUALS"]
        }
      }
    }
  }
}

