locals {
  business_units = {
    "CICA" = {
      tags         = ["CICA", "cica"]
      aws_accounts = data.aws_organizations_organizational_unit_descendant_accounts.cica.accounts[*].id
    },
    "HMCTS" = {
      tags         = ["HMCTS"]
      aws_accounts = data.aws_organizations_organizational_unit_descendant_accounts.hmcts.accounts[*].id
    },
    "HMPPS" = {
      tags         = ["HMPPS", "hmpps"]
      aws_accounts = data.aws_organizations_organizational_unit_descendant_accounts.hmpps.accounts[*].id
    },
    "HQ" = {
      tags         = ["HQ", "MoJO-HQ", "hq"]
      aws_accounts = []
    },
    "LAA" = {
      tags         = ["LAA", "laa", "legal-aid-agency"]
      aws_accounts = data.aws_organizations_organizational_unit_descendant_accounts.laa.accounts[*].id
    },
    "OPG" = {
      tags         = ["OPG", "opg"]
      aws_accounts = data.aws_organizations_organizational_unit_descendant_accounts.opg.accounts[*].id
    },
    "Platforms" = {
      tags         = ["Platform", "Platforms", "platforms"]
      aws_accounts = []
    },
    "YJB" = {
      tags         = ["YJB", "yjb"]
      aws_accounts = data.aws_organizations_organizational_unit_descendant_accounts.yjb.accounts[*].id
    },
  }
}

import {
  to = aws_ce_cost_category.business_unit
  id = "arn:aws:ce::${data.aws_caller_identity.current.account_id}:costcategory/c52f8445-757f-404e-bb15-5009ba09fe15"
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
          values        = rule.value.tags
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

  # Rule 3: Default for resources without `business-unit` Tag
  rule {
    value = "No business-unit Tag"
    rule {
      tags {
        key           = "business-unit"
        match_options = ["ABSENT"]
      }
    }
  }
}


