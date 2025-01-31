data "aws_organizations_organization" "org" {}

data "aws_organizations_organizational_unit" "modernisation_platform" {
  parent_id = data.aws_organizations_organization.org.roots[0].id
  name      = "Modernisation Platform"
}

data "aws_organizations_organizational_unit_descendant_accounts" "modernisation_platform" {
  parent_id = data.aws_organizations_organizational_unit.modernisation_platform.id
}

resource "aws_ce_cost_category" "modernisation_platform" {
  name = "Modernisation Platform"
  rule {
    rule {
      dimension {
        key           = "LINKED_ACCOUNT"
        values        = data.aws_organizations_organizational_unit_descendant_accounts.modernisation_platform.accounts[*].id
        match_options = ["EQUALS"]
      }
    }
  }
}

