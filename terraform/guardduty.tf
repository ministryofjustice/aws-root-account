# Accounts to attach from the AWS Organization
# This is currently done by adding accounts on a one-by-one basis as
# we need to onboard people singularly rather than all at once.
# In the future we can replace all of this with a for_each on a
# data.aws_organizations_organization.example.accounts[*].id data resource,
# and auto_enable will be turned on so new accounts won't need to be added here.
# Any account added here in the meanwhile will have GuardDuty enabled in:
# - eu-west-2
# - eu-west-1

# The configuration for the publishing destination is in guardduty-publishing-destination.tf,
# which has an eu-west-2 bucket that all regional GuardDuty configurations publish to.
locals {
  enrolled_into_guardduty = concat([
    { id = local.caller_identity.account_id, name = "MoJ root account" },
    aws_organizations_account.analytical-platform-data-engineering,
    aws_organizations_account.analytical-platform-development,
    aws_organizations_account.analytical-platform-landing,
    aws_organizations_account.analytical-platform-production,
    aws_organizations_account.analytics-platform-development,
    aws_organizations_account.aws-laa,
    aws_organizations_account.bichard7-2020-prototype,
    aws_organizations_account.cica,
    aws_organizations_account.cica-development,
    aws_organizations_account.cica-test-verify,
    aws_organizations_account.cica-uat,
    aws_organizations_account.cloud-networks-psn,
    aws_organizations_account.cloud-platform,
    aws_organizations_account.cloud-platform-ephemeral-test,
    aws_organizations_account.cloud-platform-transit-gateways,
    aws_organizations_account.electronic-monitoring-archive-query-service,
    aws_organizations_account.electronic-monitoring-identity-access-management,
    aws_organizations_account.electronic-monitoring-infrastructure-dev,
    aws_organizations_account.electronic-monitoring-monitoring-mapping-dev,
    aws_organizations_account.electronic-monitoring-monitoring-mapping-pre-prod,
    aws_organizations_account.electronic-monitoring-monitoring-mapping-prod,
    aws_organizations_account.electronic-monitoring-monitoring-mapping-test,
    aws_organizations_account.electronic-monitoring-protective-monitoring,
    aws_organizations_account.electronic-monitoring-shared-logging,
    aws_organizations_account.electronic-monitoring-shared-networking,
    aws_organizations_account.electronic-monitoring-shared-networking-non-prod,
    aws_organizations_account.electronic-monitoring-tagging-hardware-pre-prod,
    aws_organizations_account.electronic-monitoring-tagging-hardware-prod,
    aws_organizations_account.electronic-monitoring-tagging-hardware-test,
    aws_organizations_account.hmpps-co-financing-organisation,
    aws_organizations_account.hmpps-dev,
    aws_organizations_account.hmpps-management,
    aws_organizations_account.hmpps-performance-hub,
    aws_organizations_account.hmpps-prod,
    aws_organizations_account.laa-uat,
    aws_organizations_account.legal-aid-agency,
    aws_organizations_account.manchester-traffic-dev,
    aws_organizations_account.modernisation-platform,
    aws_organizations_account.moj-analytics-platform,
    aws_organizations_account.moj-cla,
    aws_organizations_account.moj-digital-services,
    aws_organizations_account.moj-lpa-development,
    aws_organizations_account.moj-lpa-preproduction,
    aws_organizations_account.moj-official-development,
    aws_organizations_account.moj-official-pre-production,
    aws_organizations_account.moj-official-production,
    aws_organizations_account.moj-official-public-key-infrastructure,
    aws_organizations_account.moj-official-public-key-infrastructure-dev,
    aws_organizations_account.moj-official-shared-services,
    aws_organizations_account.moj-opg-digicop-development,
    aws_organizations_account.moj-opg-digicop-preproduction,
    aws_organizations_account.moj-opg-digicop-production,
    aws_organizations_account.moj-opg-identity,
    aws_organizations_account.moj-opg-lpa-production,
    aws_organizations_account.moj-opg-lpa-refunds-development,
    aws_organizations_account.moj-opg-lpa-refunds-preproduction,
    aws_organizations_account.moj-opg-lpa-refunds-production,
    aws_organizations_account.moj-opg-management,
    aws_organizations_account.moj-opg-sandbox,
    aws_organizations_account.moj-opg-shared-development,
    aws_organizations_account.moj-opg-shared-production,
    aws_organizations_account.moj-opg-sirius-development,
    aws_organizations_account.moj-opg-sirius-preproduction,
    aws_organizations_account.moj-opg-sirius-production,
    aws_organizations_account.moj-security,
    aws_organizations_account.opg-backups,
    aws_organizations_account.opg-digi-deps-dev,
    aws_organizations_account.opg-digi-deps-preprod,
    aws_organizations_account.opg-digi-deps-prod,
    aws_organizations_account.opg-lpa-production,
    aws_organizations_account.opg-refund-develop,
    aws_organizations_account.opg-refund-production,
    aws_organizations_account.opg-shared,
    aws_organizations_account.opg-sirius-backup,
    aws_organizations_account.opg-sirius-dev,
    aws_organizations_account.opg-sirius-production,
    aws_organizations_account.opg-use-my-lpa-development,
    aws_organizations_account.opg-use-my-lpa-preproduction,
    aws_organizations_account.opg-use-my-lpa-production,
    aws_organizations_account.organisation-logging,
    aws_organizations_account.patterns,
    aws_organizations_account.security-engineering,
    aws_organizations_account.security-logging-platform,
    aws_organizations_account.security-operations-development,
    aws_organizations_account.security-operations-pre-production,
    aws_organizations_account.security-operations-production,
    aws_organizations_account.tacticalproducts,
    aws_organizations_account.workplace-tech-proof-of-concept-development,
    aws_organizations_account.wptpoc
  ], local.modernisation-platform-managed-account-ids)
}

###########################
# GuardDuty in US regions #
###########################
module "guardduty-us-east-1" {
  source = "./modules/guardduty"

  providers = {
    aws.root-account            = aws.aws-root-account-us-east-1
    aws.delegated-administrator = aws.organisation-security-us-east-1
  }

  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  enrolled_into_guardduty = {
    for account in local.enrolled_into_guardduty :
    account.name => account.id
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags-organisation-management, {
      component = "Security"
  })

  depends_on = [
    aws_organizations_organization.default,
    aws_s3_bucket_policy.guardduty-bucket-policy
  ]
}

module "guardduty-us-east-2" {
  source = "./modules/guardduty"

  providers = {
    aws.root-account            = aws.aws-root-account-us-east-2
    aws.delegated-administrator = aws.organisation-security-us-east-2
  }

  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  enrolled_into_guardduty = {
    for account in local.enrolled_into_guardduty :
    account.name => account.id
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags-organisation-management, {
      component = "Security"
  })

  depends_on = [
    aws_organizations_organization.default,
    aws_s3_bucket_policy.guardduty-bucket-policy
  ]
}

module "guardduty-us-west-1" {
  source = "./modules/guardduty"

  providers = {
    aws.root-account            = aws.aws-root-account-us-west-1
    aws.delegated-administrator = aws.organisation-security-us-west-1
  }

  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  enrolled_into_guardduty = {
    for account in local.enrolled_into_guardduty :
    account.name => account.id
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags-organisation-management, {
      component = "Security"
  })

  depends_on = [
    aws_organizations_organization.default,
    aws_s3_bucket_policy.guardduty-bucket-policy
  ]
}

module "guardduty-us-west-2" {
  source = "./modules/guardduty"

  providers = {
    aws.root-account            = aws.aws-root-account-us-west-2
    aws.delegated-administrator = aws.organisation-security-us-west-2
  }

  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  enrolled_into_guardduty = {
    for account in local.enrolled_into_guardduty :
    account.name => account.id
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags-organisation-management, {
      component = "Security"
  })

  depends_on = [
    aws_organizations_organization.default,
    aws_s3_bucket_policy.guardduty-bucket-policy
  ]
}

###########################
# GuardDuty in AP regions #
###########################
module "guardduty-ap-south-1" {
  source = "./modules/guardduty"

  providers = {
    aws.root-account            = aws.aws-root-account-ap-south-1
    aws.delegated-administrator = aws.organisation-security-ap-south-1
  }

  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  enrolled_into_guardduty = {
    for account in local.enrolled_into_guardduty :
    account.name => account.id
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags-organisation-management, {
      component = "Security"
  })

  depends_on = [
    aws_organizations_organization.default,
    aws_s3_bucket_policy.guardduty-bucket-policy
  ]
}

module "guardduty-ap-northeast-2" {
  source = "./modules/guardduty"

  providers = {
    aws.root-account            = aws.aws-root-account-ap-northeast-2
    aws.delegated-administrator = aws.organisation-security-ap-northeast-2
  }

  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  enrolled_into_guardduty = {
    for account in local.enrolled_into_guardduty :
    account.name => account.id
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags-organisation-management, {
      component = "Security"
  })

  depends_on = [
    aws_organizations_organization.default,
    aws_s3_bucket_policy.guardduty-bucket-policy
  ]
}

module "guardduty-ap-southeast-1" {
  source = "./modules/guardduty"

  providers = {
    aws.root-account            = aws.aws-root-account-ap-southeast-1
    aws.delegated-administrator = aws.organisation-security-ap-southeast-1
  }

  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  enrolled_into_guardduty = {
    for account in local.enrolled_into_guardduty :
    account.name => account.id
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags-organisation-management, {
      component = "Security"
  })

  depends_on = [
    aws_organizations_organization.default,
    aws_s3_bucket_policy.guardduty-bucket-policy
  ]
}

module "guardduty-ap-southeast-2" {
  source = "./modules/guardduty"

  providers = {
    aws.root-account            = aws.aws-root-account-ap-southeast-2
    aws.delegated-administrator = aws.organisation-security-ap-southeast-2
  }

  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  enrolled_into_guardduty = {
    for account in local.enrolled_into_guardduty :
    account.name => account.id
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags-organisation-management, {
      component = "Security"
  })

  depends_on = [
    aws_organizations_organization.default,
    aws_s3_bucket_policy.guardduty-bucket-policy
  ]
}

module "guardduty-ap-northeast-1" {
  source = "./modules/guardduty"

  providers = {
    aws.root-account            = aws.aws-root-account-ap-northeast-1
    aws.delegated-administrator = aws.organisation-security-ap-northeast-1
  }

  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  enrolled_into_guardduty = {
    for account in local.enrolled_into_guardduty :
    account.name => account.id
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags-organisation-management, {
      component = "Security"
  })

  depends_on = [
    aws_organizations_organization.default,
    aws_s3_bucket_policy.guardduty-bucket-policy
  ]
}

###########################
# GuardDuty in CA regions #
###########################
module "guardduty-ca-central-1" {
  source = "./modules/guardduty"

  providers = {
    aws.root-account            = aws.aws-root-account-ca-central-1
    aws.delegated-administrator = aws.organisation-security-ca-central-1
  }

  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  enrolled_into_guardduty = {
    for account in local.enrolled_into_guardduty :
    account.name => account.id
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags-organisation-management, {
      component = "Security"
  })

  depends_on = [
    aws_organizations_organization.default,
    aws_s3_bucket_policy.guardduty-bucket-policy
  ]
}

###########################
# GuardDuty in EU regions #
###########################
module "guardduty-eu-central-1" {
  source = "./modules/guardduty"

  providers = {
    aws.root-account            = aws.aws-root-account-eu-central-1
    aws.delegated-administrator = aws.organisation-security-eu-central-1
  }

  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  enrolled_into_guardduty = {
    for account in local.enrolled_into_guardduty :
    account.name => account.id
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags-organisation-management, {
      component = "Security"
  })

  depends_on = [
    aws_organizations_organization.default,
    aws_s3_bucket_policy.guardduty-bucket-policy
  ]
}

module "guardduty-eu-west-1" {
  source = "./modules/guardduty"

  providers = {
    aws.root-account            = aws.aws-root-account-eu-west-1
    aws.delegated-administrator = aws.organisation-security-eu-west-1
  }

  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  enrolled_into_guardduty = {
    for account in local.enrolled_into_guardduty :
    account.name => account.id
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags-organisation-management, {
      component = "Security"
  })

  depends_on = [
    aws_organizations_organization.default,
    aws_s3_bucket_policy.guardduty-bucket-policy
  ]
}

module "guardduty-eu-west-2" {
  source = "./modules/guardduty"

  providers = {
    aws.root-account            = aws.aws-root-account-eu-west-2
    aws.delegated-administrator = aws.organisation-security-eu-west-2
  }

  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  enrolled_into_guardduty = {
    for account in local.enrolled_into_guardduty :
    account.name => account.id
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags-organisation-management, {
      component = "Security"
  })

  depends_on = [
    aws_organizations_organization.default,
    aws_s3_bucket_policy.guardduty-bucket-policy
  ]
}

module "guardduty-eu-west-3" {
  source = "./modules/guardduty"

  providers = {
    aws.root-account            = aws.aws-root-account-eu-west-3
    aws.delegated-administrator = aws.organisation-security-eu-west-3
  }

  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  enrolled_into_guardduty = {
    for account in local.enrolled_into_guardduty :
    account.name => account.id
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags-organisation-management, {
      component = "Security"
  })

  depends_on = [
    aws_organizations_organization.default,
    aws_s3_bucket_policy.guardduty-bucket-policy
  ]
}

module "guardduty-eu-north-1" {
  source = "./modules/guardduty"

  providers = {
    aws.root-account            = aws.aws-root-account-eu-north-1
    aws.delegated-administrator = aws.organisation-security-eu-north-1
  }

  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  enrolled_into_guardduty = {
    for account in local.enrolled_into_guardduty :
    account.name => account.id
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags-organisation-management, {
      component = "Security"
  })

  depends_on = [
    aws_organizations_organization.default,
    aws_s3_bucket_policy.guardduty-bucket-policy
  ]
}

###########################
# GuardDuty in SA regions #
###########################
module "guardduty-sa-east-1" {
  source = "./modules/guardduty"

  providers = {
    aws.root-account            = aws.aws-root-account-sa-east-1
    aws.delegated-administrator = aws.organisation-security-sa-east-1
  }

  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  enrolled_into_guardduty = {
    for account in local.enrolled_into_guardduty :
    account.name => account.id
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags-organisation-management, {
      component = "Security"
  })

  depends_on = [
    aws_organizations_organization.default,
    aws_s3_bucket_policy.guardduty-bucket-policy
  ]
}
