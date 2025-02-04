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

  # Rule 1: Priortise the `business-unit` Tag For Allocating Cost
  rule {
    type  = "REGULAR"
    value = "HMPPS"
    rule {
      tags {
        key           = "business-unit"
        values        = toset(["HMPPS", "hmpps"])
        match_options = ["EQUALS"]
      }
    }
  }

  rule {
    type  = "REGULAR"
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
    type  = "REGULAR"
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
    type  = "REGULAR"
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
    type  = "REGULAR"
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
    type  = "REGULAR"
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
    type  = "REGULAR"
    value = "HMCTS"
    rule {
      tags {
        key           = "business-unit"
        values        = toset(["HMCTS"])
        match_options = ["EQUALS"]
      }
    }
  }

  # Rule 2: If No `business-unit` Tag, Assign Cost Based on the Organizational Unit
  rule {
    value = "HMPPS"
    rule {
      dimension {
        key           = "LINKED_ACCOUNT"
        values        = data.aws_organizations_organizational_unit_descendant_accounts.hmpps.accounts[*].id
        match_options = ["EQUALS"]
      }
    }
  }

  rule {
    value = "LAA"
    rule {
      dimension {
        key           = "LINKED_ACCOUNT"
        values        = data.aws_organizations_organizational_unit_descendant_accounts.laa.accounts[*].id
        match_options = ["EQUALS"]
      }
    }
  }

  rule {
    value = "OPG"
    rule {
      dimension {
        key           = "LINKED_ACCOUNT"
        values        = data.aws_organizations_organizational_unit_descendant_accounts.opg.accounts[*].id
        match_options = ["EQUALS"]
      }
    }
  }

  rule {
    value = "CICA"
    rule {
      dimension {
        key           = "LINKED_ACCOUNT"
        values        = data.aws_organizations_organizational_unit_descendant_accounts.cica.accounts[*].id
        match_options = ["EQUALS"]
      }
    }
  }

  rule {
    value = "YJB"
    rule {
      dimension {
        key           = "LINKED_ACCOUNT"
        values        = data.aws_organizations_organizational_unit_descendant_accounts.yjb.accounts[*].id
        match_options = ["EQUALS"]
      }
    }
  }

  rule {
    value = "HMCTS"
    rule {
      dimension {
        key           = "LINKED_ACCOUNT"
        values        = data.aws_organizations_organizational_unit_descendant_accounts.hmcts.accounts[*].id
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

