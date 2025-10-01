# Accounts to enrol from the AWS Organization
#
# The configuration for the publishing destination is in guardduty-publishing-destination.tf,
# which has an eu-west-2 bucket that all regional GuardDuty configurations publish to.

# Prior to 4th May 2021, no regions had auto-enable turned on. To speed up and
# simplify this Terraform, auto-enable was turned on in the below regions. This
# allows us to deprecate the enrolled_into_guardduty variable for those regions,
# and we can rely on auto-enable to automatically enable GuardDuty for **new** AWS
# accounts created after 4th May 2021. This resulted in 1,288 (184 accounts * 7 regions)
# resources being removed from the state, nearly halving the time Terraform took
# to run.
#
# The AWS API also doesn't return the status of a member account (whether GuardDuty
# is enabled or not), so it didn't provide much value other than the initial association
# as a member account.
# See: https://docs.aws.amazon.com/guardduty/latest/APIReference/API_Member.html
#
# The following regions have auto-enable turned **on**:
# See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_organization_configuration
# eu-*
# us-*
# ap-*
# ca-*
# sa-*
#
# In the event of having to recreate this AWS Organization, we can assume that
# auto-enable will automatically create the member associations for the accounts.
# Therefore, the aws_guardduty_member resources have been removed from regions
# where auto-enable is now turned on as of 4th May 2021.

###########################
# GuardDuty in US regions #
###########################
module "guardduty_us_east_1" {
  source = "../../modules/guardduty-org-sec"

  providers = { aws.delegated_administrator = aws.us-east-1 }

  administrator_detector_id = local.guardduty_administrator_detector_ids.us_east_1

  # Utilise ThreatIntelSet
  enable_threatintelset = false
  threatintelset_key    = aws_s3_object.guardduty_threatintelset.key
  threatintelset_bucket = aws_s3_object.guardduty_threatintelset.bucket

  # Automatically enable GuardDuty for us-east-1
  auto_enable = true

  destination_arn = module.guardduty_publishing_destination_s3_bucket.bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })

  depends_on = [
    module.guardduty_publishing_destination_s3_bucket
  ]
}

module "guardduty_us_east_2" {
  source = "../../modules/guardduty-org-sec"

  providers = { aws.delegated_administrator = aws.us-east-2 }

  administrator_detector_id = local.guardduty_administrator_detector_ids.us_east_2

  # Utilise ThreatIntelSet
  enable_threatintelset = false
  threatintelset_key    = aws_s3_object.guardduty_threatintelset.key
  threatintelset_bucket = aws_s3_object.guardduty_threatintelset.bucket

  # Automatically enable GuardDuty for us-east-2
  auto_enable = true

  destination_arn = module.guardduty_publishing_destination_s3_bucket.bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })

  depends_on = [
    module.guardduty_publishing_destination_s3_bucket
  ]
}

module "guardduty_us_west_1" {
  source = "../../modules/guardduty-org-sec"

  providers = { aws.delegated_administrator = aws.us-west-1 }

  administrator_detector_id = local.guardduty_administrator_detector_ids.us_west_1

  # Utilise ThreatIntelSet
  enable_threatintelset = false
  threatintelset_key    = aws_s3_object.guardduty_threatintelset.key
  threatintelset_bucket = aws_s3_object.guardduty_threatintelset.bucket

  # Automatically enable GuardDuty for us-west-1
  auto_enable = true

  destination_arn = module.guardduty_publishing_destination_s3_bucket.bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })

  depends_on = [
    module.guardduty_publishing_destination_s3_bucket
  ]
}

module "guardduty_us_west_2" {
  source = "../../modules/guardduty-org-sec"

  providers = { aws.delegated_administrator = aws.us-west-2 }

  administrator_detector_id = local.guardduty_administrator_detector_ids.us_west_2

  # Utilise ThreatIntelSet
  enable_threatintelset = false
  threatintelset_key    = aws_s3_object.guardduty_threatintelset.key
  threatintelset_bucket = aws_s3_object.guardduty_threatintelset.bucket

  # Automatically enable GuardDuty for us-west-2
  auto_enable = true

  destination_arn = module.guardduty_publishing_destination_s3_bucket.bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn


  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })

  depends_on = [
    module.guardduty_publishing_destination_s3_bucket
  ]
}

###########################
# GuardDuty in AP regions #
###########################
module "guardduty_ap_south_1" {
  source = "../../modules/guardduty-org-sec"

  providers = { aws.delegated_administrator = aws.ap-south-1 }

  administrator_detector_id = local.guardduty_administrator_detector_ids.ap_south_1

  # Utilise ThreatIntelSet
  enable_threatintelset = false
  threatintelset_key    = aws_s3_object.guardduty_threatintelset.key
  threatintelset_bucket = aws_s3_object.guardduty_threatintelset.bucket

  # Automatically enable GuardDuty for ap-south-1
  auto_enable = true

  destination_arn = module.guardduty_publishing_destination_s3_bucket.bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn


  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })

  depends_on = [
    module.guardduty_publishing_destination_s3_bucket
  ]
}

module "guardduty_ap_northeast_3" {
  source = "../../modules/guardduty-org-sec"

  providers = { aws.delegated_administrator = aws.ap-northeast-3 }

  administrator_detector_id = local.guardduty_administrator_detector_ids.ap_northeast_3

  # Utilise ThreatIntelSet
  enable_threatintelset = false
  threatintelset_key    = aws_s3_object.guardduty_threatintelset.key
  threatintelset_bucket = aws_s3_object.guardduty_threatintelset.bucket

  # Automatically enable GuardDuty for ap-northeast-3
  auto_enable = true

  destination_arn = module.guardduty_publishing_destination_s3_bucket.bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn


  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })

  depends_on = [
    module.guardduty_publishing_destination_s3_bucket
  ]
}

module "guardduty_ap_northeast_2" {
  source = "../../modules/guardduty-org-sec"

  providers = { aws.delegated_administrator = aws.ap-northeast-2 }

  administrator_detector_id = local.guardduty_administrator_detector_ids.ap_northeast_2

  # Utilise ThreatIntelSet
  enable_threatintelset = false
  threatintelset_key    = aws_s3_object.guardduty_threatintelset.key
  threatintelset_bucket = aws_s3_object.guardduty_threatintelset.bucket

  # Automatically enable GuardDuty for ap-northeast-2
  auto_enable = true

  destination_arn = module.guardduty_publishing_destination_s3_bucket.bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn


  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })

  depends_on = [
    module.guardduty_publishing_destination_s3_bucket
  ]
}

module "guardduty_ap_southeast_1" {
  source = "../../modules/guardduty-org-sec"

  providers = { aws.delegated_administrator = aws.ap-southeast-1 }

  administrator_detector_id = local.guardduty_administrator_detector_ids.ap_southeast_1

  # Utilise ThreatIntelSet
  enable_threatintelset = false
  threatintelset_key    = aws_s3_object.guardduty_threatintelset.key
  threatintelset_bucket = aws_s3_object.guardduty_threatintelset.bucket

  # Automatically enable GuardDuty for ap-southeast-1
  auto_enable = true

  destination_arn = module.guardduty_publishing_destination_s3_bucket.bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn


  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })

  depends_on = [
    module.guardduty_publishing_destination_s3_bucket
  ]
}

module "guardduty_ap_southeast_2" {
  source = "../../modules/guardduty-org-sec"

  providers = { aws.delegated_administrator = aws.ap-southeast-2 }

  administrator_detector_id = local.guardduty_administrator_detector_ids.ap_southeast_2

  # Utilise ThreatIntelSet
  enable_threatintelset = false
  threatintelset_key    = aws_s3_object.guardduty_threatintelset.key
  threatintelset_bucket = aws_s3_object.guardduty_threatintelset.bucket

  # Automatically enable GuardDuty for ap-southeast-2
  auto_enable = true

  destination_arn = module.guardduty_publishing_destination_s3_bucket.bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn


  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })

  depends_on = [
    module.guardduty_publishing_destination_s3_bucket
  ]
}

module "guardduty_ap_northeast_1" {
  source = "../../modules/guardduty-org-sec"

  providers = { aws.delegated_administrator = aws.ap-northeast-1 }

  administrator_detector_id = local.guardduty_administrator_detector_ids.ap_northeast_1

  # Utilise ThreatIntelSet
  enable_threatintelset = false
  threatintelset_key    = aws_s3_object.guardduty_threatintelset.key
  threatintelset_bucket = aws_s3_object.guardduty_threatintelset.bucket

  # Automatically enable GuardDuty for ap-northeast-1
  auto_enable = true

  destination_arn = module.guardduty_publishing_destination_s3_bucket.bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn


  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })

  depends_on = [
    module.guardduty_publishing_destination_s3_bucket
  ]
}

###########################
# GuardDuty in CA regions #
###########################
module "guardduty_ca_central_1" {
  source = "../../modules/guardduty-org-sec"

  providers = { aws.delegated_administrator = aws.ca-central-1 }

  administrator_detector_id = local.guardduty_administrator_detector_ids.ca_central_1

  # Utilise ThreatIntelSet
  enable_threatintelset = false
  threatintelset_key    = aws_s3_object.guardduty_threatintelset.key
  threatintelset_bucket = aws_s3_object.guardduty_threatintelset.bucket

  # Automatically enable GuardDuty for ca-central-1
  auto_enable = true

  destination_arn = module.guardduty_publishing_destination_s3_bucket.bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn


  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })

  depends_on = [
    module.guardduty_publishing_destination_s3_bucket
  ]
}

###########################
# GuardDuty in EU regions #
###########################
module "guardduty_eu_central_1" {
  source = "../../modules/guardduty-org-sec"

  providers = { aws.delegated_administrator = aws.eu-central-1 }

  administrator_detector_id = local.guardduty_administrator_detector_ids.eu_central_1

  # Utilise ThreatIntelSet
  enable_threatintelset = false
  threatintelset_key    = aws_s3_object.guardduty_threatintelset.key
  threatintelset_bucket = aws_s3_object.guardduty_threatintelset.bucket

  # Automatically enable GuardDuty for eu-central-1
  auto_enable = true

  destination_arn = module.guardduty_publishing_destination_s3_bucket.bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn


  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })

  depends_on = [
    module.guardduty_publishing_destination_s3_bucket
  ]
}

module "guardduty_eu_central_2" {
  source = "../../modules/guardduty-org-sec"

  providers = { aws.delegated_administrator = aws.eu-central-2 }

  administrator_detector_id = local.guardduty_administrator_detector_ids.eu_central_2

  # Utilise ThreatIntelSet
  enable_threatintelset = false
  threatintelset_key    = aws_s3_object.guardduty_threatintelset.key
  threatintelset_bucket = aws_s3_object.guardduty_threatintelset.bucket

  # Automatically enable GuardDuty for eu-central-2
  auto_enable = true

  destination_arn = module.guardduty_publishing_destination_s3_bucket.bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn


  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })

  depends_on = [
    module.guardduty_publishing_destination_s3_bucket
  ]
}

module "guardduty_eu_west_1" {
  source = "../../modules/guardduty-org-sec"

  providers = { aws.delegated_administrator = aws.eu-west-1 }

  administrator_detector_id = local.guardduty_administrator_detector_ids.eu_west_1

  # Utilise ThreatIntelSet
  enable_threatintelset = false
  threatintelset_key    = aws_s3_object.guardduty_threatintelset.key
  threatintelset_bucket = aws_s3_object.guardduty_threatintelset.bucket

  # Automatically enable GuardDuty for eu-west-1
  auto_enable = true

  destination_arn = module.guardduty_publishing_destination_s3_bucket.bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn


  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })

  depends_on = [
    module.guardduty_publishing_destination_s3_bucket
  ]
}

module "guardduty_eu_west_2" {
  source = "../../modules/guardduty-org-sec"

  providers = { aws.delegated_administrator = aws.eu-west-2 }

  administrator_detector_id = local.guardduty_administrator_detector_ids.eu_west_2

  # Utilise ThreatIntelSet
  enable_threatintelset = false
  threatintelset_key    = aws_s3_object.guardduty_threatintelset.key
  threatintelset_bucket = aws_s3_object.guardduty_threatintelset.bucket

  # Automatically enable GuardDuty for eu-west-2
  auto_enable = true

  destination_arn = module.guardduty_publishing_destination_s3_bucket.bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn


  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })

  depends_on = [
    module.guardduty_publishing_destination_s3_bucket
  ]
}

module "guardduty_eu_west_3" {
  source = "../../modules/guardduty-org-sec"

  providers = { aws.delegated_administrator = aws.eu-west-3 }

  administrator_detector_id = local.guardduty_administrator_detector_ids.eu_west_3

  # Utilise ThreatIntelSet
  enable_threatintelset = false
  threatintelset_key    = aws_s3_object.guardduty_threatintelset.key
  threatintelset_bucket = aws_s3_object.guardduty_threatintelset.bucket

  # Automatically enable GuardDuty for eu-west-3
  auto_enable = true

  destination_arn = module.guardduty_publishing_destination_s3_bucket.bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn


  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })

  depends_on = [
    module.guardduty_publishing_destination_s3_bucket
  ]
}

module "guardduty_eu_north_1" {
  source = "../../modules/guardduty-org-sec"

  providers = { aws.delegated_administrator = aws.eu-north-1 }

  administrator_detector_id = local.guardduty_administrator_detector_ids.eu_north_1

  # Utilise ThreatIntelSet
  enable_threatintelset = false
  threatintelset_key    = aws_s3_object.guardduty_threatintelset.key
  threatintelset_bucket = aws_s3_object.guardduty_threatintelset.bucket

  # Automatically enable GuardDuty for eu-north-1
  auto_enable = true

  destination_arn = module.guardduty_publishing_destination_s3_bucket.bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn


  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })

  depends_on = [
    module.guardduty_publishing_destination_s3_bucket
  ]
}

###########################
# GuardDuty in SA regions #
###########################
module "guardduty_sa_east_1" {
  source = "../../modules/guardduty-org-sec"

  providers = { aws.delegated_administrator = aws.sa-east-1 }

  administrator_detector_id = local.guardduty_administrator_detector_ids.sa_east_1

  # Utilise ThreatIntelSet
  enable_threatintelset = false
  threatintelset_key    = aws_s3_object.guardduty_threatintelset.key
  threatintelset_bucket = aws_s3_object.guardduty_threatintelset.bucket

  # Automatically enable GuardDuty for sa-east-1
  auto_enable = true

  destination_arn = module.guardduty_publishing_destination_s3_bucket.bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn


  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })

  depends_on = [
    module.guardduty_publishing_destination_s3_bucket
  ]
}
