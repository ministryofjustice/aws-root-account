data "awscc_organizations_accounts" "all" {}

data "awscc_organizations_account" "all" {
  for_each = data.awscc_organizations_accounts.all.ids
  id       = each.value
}

locals {
  all_aws_accounts_with_business_unit_tag = {
    for k, v in data.awscc_organizations_account.all :
    k => {
      "id" = v.id
      "business_unit" = one(flatten([
        for tag in coalesce(v.tags, []) :
        tag.value if tag.key == "business-unit"
      ]))
    }
  }
  business_units = {
    "Central Digital" = {
      businss_unit_tag_values = ["Central Digital", "central-digital", "CJSE"]
      aws_accounts            = data.aws_organizations_organizational_unit_descendant_accounts.central_digital.accounts[*].id
      tagged_aws_accounts     = []
    },
    "CICA" = {
      businss_unit_tag_values = ["CICA", "cica"]
      aws_accounts            = data.aws_organizations_organizational_unit_descendant_accounts.cica.accounts[*].id
      tagged_aws_accounts     = []
    },
    "HMCTS" = {
      businss_unit_tag_values = ["HMCTS"]
      aws_accounts            = data.aws_organizations_organizational_unit_descendant_accounts.hmcts.accounts[*].id
      tagged_aws_accounts     = []
    },
    "HMPPS" = {
      businss_unit_tag_values = ["HMPPS", "hmpps"]
      aws_accounts            = data.aws_organizations_organizational_unit_descendant_accounts.hmpps.accounts[*].id
      tagged_aws_accounts = [
        for k, v in local.all_aws_accounts_with_business_unit_tag :
        v.id
        if v.business_unit == "HMPPS"
      ]
    },
    "LAA" = {
      businss_unit_tag_values = ["LAA", "laa", "legal-aid-agency"]
      aws_accounts            = data.aws_organizations_organizational_unit_descendant_accounts.laa.accounts[*].id
      tagged_aws_accounts     = []
    },
    "OPG" = {
      businss_unit_tag_values = ["OPG", "opg"]
      aws_accounts            = data.aws_organizations_organizational_unit_descendant_accounts.opg.accounts[*].id
      tagged_aws_accounts     = []
    },
    "Platforms" = {
      businss_unit_tag_values = ["Platforms", "Platform", "platforms"]
      aws_accounts            = []
      tagged_aws_accounts     = []
    },
    "Technology Services" = {
      businss_unit_tag_values = ["Technology Services", "technology-services"]
      aws_accounts            = data.aws_organizations_organizational_unit_descendant_accounts.technology_services.accounts[*].id
      tagged_aws_accounts     = []
    },
    "YJB" = {
      businss_unit_tag_values = ["YJB", "yjb"]
      aws_accounts            = data.aws_organizations_organizational_unit_descendant_accounts.yjb.accounts[*].id
      tagged_aws_accounts     = []
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
  effective_start = "2025-02-01T00:00:00Z"

  # Rule 1: Prioritize the Resources `business-unit` Tag for Allocating Cost
  dynamic "rule" {
    for_each = { for k, v in local.business_units : k => v if length(v.businss_unit_tag_values) > 0 }
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

  # Rule 2: If No Resource `business-unit` Tag, Assign Cost Based on the Account `business-unit` Tag
  dynamic "rule" {
    for_each = { for k, v in local.business_units : k => v if length(v.tagged_aws_accounts) > 0 }
    content {
      type  = "REGULAR"
      value = rule.key

      rule {
        dimension {
          key           = "LINKED_ACCOUNT"
          values        = rule.value.tagged_aws_accounts
          match_options = ["EQUALS"]
        }
      }
    }
  }

  # Rule 3: If No `business-unit` Tag, Assign Cost Based on the Organizational Unit
  dynamic "rule" {
    for_each = { for k, v in local.business_units : k => v if length(v.aws_accounts) > 0 }
    content {
      type  = "REGULAR"
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

