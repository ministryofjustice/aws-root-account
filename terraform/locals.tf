data "aws_caller_identity" "current" {}

locals {
  root_account = {
    business-unit = "Platforms"
    application   = "AWS root account"
    is-production = true
    owner         = "Hosting Leads: hosting-leads@digital.justice.gov.uk"
  }
  caller_identity   = data.aws_caller_identity.current
  github_repository = "github.com/ministryofjustice/aws-root-account/blob/main/terraform"
}

locals {
  tags-business-unit = {
    hq = {
      business-unit = "HQ"
      is-production = false
    },
    hmpps = {
      business-unit = "HMPPS"
      is-production = false
    },
    opg = {
      business-unit = "OPG"
      is-production = false
    },
    laa = {
      business-unit = "LAA"
      is-production = false
    },
    hmcts = {
      business-unit = "HMCTS"
      is-production = false
    },
    cica = {
      business-unit = "CICA"
      is-production = false
    },
    platforms = {
      business-unit = "Platforms"
      is-production = false
    }
  }
}
