data "aws_organizations_organizational_unit_descendant_accounts" "modernisation_platform" {
  parent_id = aws_organizations_organizational_unit.platforms_and_architecture_modernisation_platform.id
}

resource "aws_ce_cost_category" "modernisation_platform" {
  name            = "Modernisation Platform"
  rule_version    = "CostCategoryExpression.v1"
  effective_start = "2024-02-01T00:00:00Z"
  rule {
    type  = "REGULAR"
    value = "Modernisation Platform"
    rule {
      dimension {
        key           = "LINKED_ACCOUNT"
        values        = data.aws_organizations_organizational_unit_descendant_accounts.modernisation_platform.accounts[*].id
        match_options = ["EQUALS"]
      }
    }
  }
}

import {
  to = aws_ce_cost_category.business_unit
  id = "arn:aws:ce::${data.aws_caller_identity.current.account_id}:costcategory/c52f8445-757f-404e-bb15-5009ba09fe15"
}

resource "aws_ce_cost_category" "business_unit" {
  name            = "Business Unit"
  rule_version    = "CostCategoryExpression.v1"
  effective_start = "2024-01-01T00:00:00Z"
  rule {
    value = "HMPPS"
    rule {
      tags {
        key           = "business-unit"
        values        = toset(["HMPPS"])
        match_options = ["EQUALS"]
      }
    }
  }

  rule {
    value = "Platforms"
    rule {
      tags {
        key           = "business-unit"
        values        = toset(["Platform", "Platforms", "platforms"])
        match_options = ["EQUALS"]
      }
    }
  }

  rule {
    value = "LAA"
    rule {
      tags {
        key           = "business-unit"
        values        = toset(["LAA", "laa", "legal-aid-agency"])
        match_options = ["EQUALS"]
      }
    }
  }

  rule {
    value = "OPG"
    rule {
      tags {
        key           = "business-unit"
        values        = toset(["OPG", "opg"])
        match_options = ["EQUALS"]
      }
    }
  }

  rule {
    value = "HQ"
    rule {
      tags {
        key           = "business-unit"
        values        = toset(["HQ", "MoJO-HQ", "hq"])
        match_options = ["EQUALS"]
      }
    }
  }

  rule {
    value = "CICA"
    rule {
      tags {
        key           = "business-unit"
        values        = toset(["CICA", "cica"])
        match_options = ["EQUALS"]
      }
    }
  }

  rule {
    value = "HMCTS"
    rule {
      tags {
        key           = "business-unit"
        values        = toset(["HMCTS"])
        match_options = ["EQUALS"]
      }
    }
  }


  rule {
    value = "HMCTS"
    rule {
      tags {
        key           = "business-unit"
        values        = toset(["HMCTS"])
        match_options = ["EQUALS"]
      }
    }
  }

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

