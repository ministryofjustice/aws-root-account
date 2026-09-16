locals {
  all_aws_accounts_with_service_area_tag = {
    for k, v in local.all_accounts :
    k => {
      id           = v.id
      name         = v.name
      service_area = coalesce(one(flatten([
        for tag in coalesce(v.tags, []) :
        tag.value if tag.key == "service-area"
      ])), "Unallocated")
    }
  }

  service_areas = {
    "Hosting" = {
      service_area_tag_values     = ["Hosting"]
      untagged_aws_account_names  = ["Cloud Platform", "Cloud Platform Ephemeral Test", "cloud-platform-development", "cloud-platform-live", "cloud-platform-live-development", "cloud-platform-live-preproduction", "cloud-platform-live-production", "cloud-platform-live-test", "cloud-platform-non-live-development", "cloud-platform-non-live-preproduction", "cloud-platform-non-live-production", "cloud-platform-non-live-test", "cloud-platform-nonlive", "cloud-platform-preproduction", "coat-development", "coat-production", "container-platform-cd-live", "container-platform-cd-nonlive", "container-platform-hmpps-live", "container-platform-hmpps-nonlive", "container-platform-laa-live", "container-platform-laa-nonlive", "container-platform-octo-live", "container-platform-octo-nonlive", "cooker-development", "core-logging", "core-network-services", "core-security", "core-shared-services", "core-shared-services-development", "core-vpc-development", "core-vpc-preproduction", "core-vpc-production", "core-vpc-sandbox", "core-vpc-test", "example-development", "Justice Engineering AI Services", "long-term-storage-production", "Modernisation Platform", "MoJ Digital Services", "MOJ Master", "observability-platform-development", "observability-platform-production", "octo-development", "octo-engineering-ai-enablement-development", "octo-engineering-ai-enablement-production", "sprinkler-development", "testing-test"]
      tagged_aws_account_names    = [for k, v in local.all_aws_accounts_with_service_area_tag : v.name if contains(["Hosting"], v.service_area)]
    },
  }
}

resource "aws_ce_cost_category" "service_area" {
  name          = "Service Area"
  default_value = "Unallocated"
  rule_version  = "CostCategoryExpression.v1"

  # Rule 0: Temporary correction for untagged service-area resources by account name
  dynamic "rule" {
    for_each = { for k, v in local.service_areas : k => v if length(v.untagged_aws_account_names) > 0 }
    content {
      type  = "REGULAR"
      value = rule.key

      rule {
        dimension {
          key           = "LINKED_ACCOUNT_NAME"
          values        = rule.value.untagged_aws_account_names
          match_options = ["EQUALS"]
        }
      }
    }
  }

  # Rule 1: Use the Resource `service-area` Cost Allocation Tag to assign cost
  dynamic "rule" {
    for_each = { for k, v in local.service_areas : k => v if length(v.service_area_tag_values) > 0 }
    content {
      type  = "REGULAR"
      value = rule.key

      rule {
        tags {
          key           = "service-area"
          values        = rule.value.service_area_tag_values
          match_options = ["EQUALS"]
        }
      }
    }
  }

  # Rule 2: If no Resource `service-area` Tag, assign cost based on the Account `service-area` Tag
  dynamic "rule" {
    for_each = { for k, v in local.service_areas : k => v if length(v.tagged_aws_account_names) > 0 }
    content {
      type  = "REGULAR"
      value = rule.key

      rule {
        dimension {
          key           = "LINKED_ACCOUNT_NAME"
          values        = rule.value.tagged_aws_account_names
          match_options = ["EQUALS"]
        }
      }
    }
  }
}
