locals {
  tags_default = {
    is-production = false
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
    laa = merge(local.tags_default, {
      business-unit = "LAA"
    })
    opg = merge(local.tags_default, {
      business-unit = "OPG"
    })
    platforms = merge(local.tags_default, {
      business-unit = "Platforms"
    })
    yjb = merge(local.tags_default, {
      business-unit = "YJB"
    })
  }
  github_repository = "github.com/ministryofjustice/aws-root-account/blob/main"
}
