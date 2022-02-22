locals {
  tags_default = {
    business-unit = ""
    application   = ""
    is-production = false
    owner         = ""
  }
  tags_business_units = {
    cica = merge(local.tags_default, {
      business-unit = "CICA"
    })
    hmcts = merge(local.tags_default, {
      business-unit = "HMCTS"
    })
    hmpps = merge(local.tags_default, {
      business-unit = "HMPPS"
    })
    hq = merge(local.tags_default, {
      business-unit = "HQ"
    })
    platforms = merge(local.tags_default, {
      business-unit = "Platforms"
    })
  }
  github_repository = "github.com/ministryofjustice/aws-root-account/blob/main"
}
