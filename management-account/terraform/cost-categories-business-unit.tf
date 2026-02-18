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
      "business_unit" = coalesce(one(flatten([
        for tag in coalesce(v.tags, []) :
        tag.value if tag.key == "business-unit"
      ])), "Uncategorised Business Unit") # 👈 coalesce() needs a non-empty string and we don't want to return null because we want to use the value with contains()
    }
  }
  business_units = {
    "Central Digital" = {
      business_unit_tag_values      = ["Central Digital", "central-digital", "CJSE"]
      aws_descendant_accounts       = data.aws_organizations_organizational_unit_descendant_accounts.central_digital.accounts[*].id
      untagged_aws_account_prefixes = ["cdpt-chaps-", "cdpt-ifs-", "genesys-call-centre-data-", "bichard7"]
      tagged_aws_accounts           = [for k, v in local.all_aws_accounts_with_business_unit_tag : v.id if contains(["Central Digital", "central-digital", "CJSE"], v.business_unit)]
    },
    "CICA" = {
      business_unit_tag_values      = ["CICA", "cica"]
      aws_descendant_accounts       = data.aws_organizations_organizational_unit_descendant_accounts.cica.accounts[*].id
      untagged_aws_account_prefixes = []
      tagged_aws_accounts           = [for k, v in local.all_aws_accounts_with_business_unit_tag : v.id if contains(["CICA", "cica"], v.business_unit)]
    },
    "HMCTS" = {
      business_unit_tag_values      = ["HMCTS"]
      aws_descendant_accounts       = data.aws_organizations_organizational_unit_descendant_accounts.hmcts.accounts[*].id
      untagged_aws_account_prefixes = []
      tagged_aws_accounts           = [for k, v in local.all_aws_accounts_with_business_unit_tag : v.id if contains(["HMCTS"], v.business_unit)]
    },
    "HMPPS" = {
      business_unit_tag_values      = ["HMPPS", "hmpps"]
      aws_descendant_accounts       = data.aws_organizations_organizational_unit_descendant_accounts.hmpps.accounts[*].id
      untagged_aws_account_prefixes = ["delius", "electronic-monitoring", "digital-prison", "nomis", "property-cafm-data-migration"]
      tagged_aws_accounts           = [for k, v in local.all_aws_accounts_with_business_unit_tag : v.id if contains(["HMPPS", "hmpps"], v.business_unit)]
    },
    "LAA" = {
      business_unit_tag_values      = ["LAA", "laa", "legal-aid-agency"]
      aws_descendant_accounts       = data.aws_organizations_organizational_unit_descendant_accounts.laa.accounts[*].id
      untagged_aws_account_prefixes = ["mlra", "ccms", "laa-ccms"]
      tagged_aws_accounts           = [for k, v in local.all_aws_accounts_with_business_unit_tag : v.id if contains(["LAA", "laa", "legal-aid-agency"], v.business_unit)]
    },
    "OPG" = {
      business_unit_tag_values      = ["OPG", "opg"]
      aws_descendant_accounts       = data.aws_organizations_organizational_unit_descendant_accounts.opg.accounts[*].id
      untagged_aws_account_prefixes = []
      tagged_aws_accounts           = [for k, v in local.all_aws_accounts_with_business_unit_tag : v.id if contains(["OPG", "opg"], v.business_unit)]
    },
    "OCTO" = {
      business_unit_tag_values      = ["Platforms", "Platform", "platforms", "OCTO"]
      aws_descendant_accounts       = []
      untagged_aws_account_prefixes = ["Security Operations Pre Production", "analytical-platform-", "data-platform-"]
      tagged_aws_accounts           = [for k, v in local.all_aws_accounts_with_business_unit_tag : v.id if contains(["Platforms", "Platform", "platforms", "OCTO"], v.business_unit)]
    },
    "Technology Services" = {
      business_unit_tag_values      = ["Technology Services", "technology-services"]
      aws_descendant_accounts       = data.aws_organizations_organizational_unit_descendant_accounts.technology_services.accounts[*].id
      untagged_aws_account_prefixes = ["moj-network-operations-centre-"]
      tagged_aws_accounts           = [for k, v in local.all_aws_accounts_with_business_unit_tag : v.id if contains(["Technology Services", "technology-services"], v.business_unit)]
    },
    "YJB" = {
      business_unit_tag_values      = ["YJB", "yjb"]
      aws_descendant_accounts       = []
      untagged_aws_account_prefixes = ["youth-justice"]
      tagged_aws_accounts           = [for k, v in local.all_aws_accounts_with_business_unit_tag : v.id if contains(["YJB", "yjb"], v.business_unit)]
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

  # Rule 0: Temporary Correction: Assign Cost Category Based on Account Prefixes
  # Due to organisational structure change some accounts currently have the wrong `business-unit` tag
  # and resource level BU tag for MP created accounts. This temporary rule allows us to correctly assign cost
  # and give teams time to correct their account `business-unit` tags.
  dynamic "rule" {
    for_each = { for k, v in local.business_units : k => v if length(v.untagged_aws_account_prefixes) > 0 }
    content {
      type  = "REGULAR"
      value = rule.key

      rule {
        dimension {
          key           = "LINKED_ACCOUNT_NAME"
          values        = rule.value.untagged_aws_account_prefixes
          match_options = ["STARTS_WITH"]
        }
      }
    }
  }

  # Rule 1: Use the Resource `business-unit` Cost Allocation Tag to assign cost
  dynamic "rule" {
    for_each = { for k, v in local.business_units : k => v if length(v.business_unit_tag_values) > 0 }
    content {
      type  = "REGULAR"
      value = rule.key

      rule {
        tags {
          key           = "business-unit"
          values        = rule.value.business_unit_tag_values
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

  # Rule 3: If No Account `business-unit` Tag, Assign Cost Based on the Organizational Unit
  dynamic "rule" {
    for_each = { for k, v in local.business_units : k => v if length(v.aws_descendant_accounts) > 0 }
    content {
      type  = "REGULAR"
      value = rule.key

      rule {
        dimension {
          key           = "LINKED_ACCOUNT"
          values        = rule.value.aws_descendant_accounts
          match_options = ["EQUALS"]
        }
      }
    }
  }
}
