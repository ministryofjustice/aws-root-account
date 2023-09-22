data "aws_caller_identity" "current" {}

data "aws_organizations_organization" "default" {}

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
  root_account = merge(local.tags-business-unit.platforms, {
    application   = "AWS root account"
    is-production = true
    owner         = "Hosting Leads: hosting-leads@digital.justice.gov.uk"
  })
  caller_identity   = data.aws_caller_identity.current
  github_repository = "github.com/ministryofjustice/aws-root-account/blob/main/terraform"

  tags-organisation-management = {
    application            = "Organisation Management"
    business-unit          = "Platforms"
    infrastructure-support = "Hosting Leads: hosting-leads@digital.justice.gov.uk"
    is-production          = true
    owner                  = "Hosting Leads: hosting-leads@digital.justice.gov.uk"
    source-code            = "github.com/ministryofjustice/aws-root-account"
  }

  organisation_security_name = "organisation-security"
  org_sec_acc_index          = index(data.aws_organizations_organization.default.accounts[*].name, local.organisation_security_name)
  organisation_security_id   = data.aws_organizations_organization.default.accounts[local.org_sec_acc_index].id
}
