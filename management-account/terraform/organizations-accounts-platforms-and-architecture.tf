# No accounts in AWS OU "Platforms & Architecture".

locals {
  tags_platforms = merge(local.tags_business_units.platforms, {
    business-unit = "Platforms"
  })
}
