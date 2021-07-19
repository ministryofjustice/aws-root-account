# Accounts to enrol from the AWS Organization
# This is currently done by adding accounts on a one-by-one basis as we need to
# onboard teams singularly, rather than all at once for eu-* and us-* regions.
#
# The configuration for the publishing destination is in guardduty-publishing-destination.tf,
# which has an eu-west-2 bucket that all regional GuardDuty configurations publish to.
#
# NOTE
# Different regions have different configurations.
#
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
# The following regions have auto-enable turned **off**:
# eu-*
# us-*
#
# The following regions have auto-enable turned **on**:
# See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_organization_configuration
# ap-*
# ca-*
# sa-*
#
# In the event of having to recreate this AWS Organization, we can assume that
# auto-enable will automatically create the member associations for the accounts.
# Therefore, the aws_guardduty_member resources have been removed from regions
# where auto-enable is now turned on as of 4th May 2021.

locals {
  # These accounts currently have an integration in eu-west-2 for GuardDuty that needs unpicking.
  # We've enrolled them into central GuardDuty in all other regions to make the transition easier.
  enrolled_into_guardduty_non_eu_west_2_only = [
    aws_organizations_account.hmpps-delius-mis-test,
    aws_organizations_account.hmpps-delius-po-test-2,
    aws_organizations_account.hmpps-delius-po-test-1,
    aws_organizations_account.hmpps-delius-training-test,
    aws_organizations_account.hmpps-delius-training,
    aws_organizations_account.hmpps-delius-mis-non-prod,
    aws_organizations_account.hmpps-victim-case-management-system-performance,
    aws_organizations_account.hmpps-victim-case-management-system-stage,
    aws_organizations_account.hmpps-victim-case-management-system-test,
    aws_organizations_account.hmpps-security-audit,
    aws_organizations_account.hmpps-engineering-production,
    aws_organizations_account.hmpps-delius-pre-production,
    aws_organizations_account.hmpps-delius-performance,
    aws_organizations_account.hmpps-delius-stage,
    aws_organizations_account.hmpps-delius-test,
    aws_organizations_account.hmpps-victim-case-management-system-pre-production,
    aws_organizations_account.hmpps-victim-case-management-system-production,
    aws_organizations_account.hmpps-victim-case-management-system-integration,
    aws_organizations_account.strategic-partner-gateway-non-production,
    aws_organizations_account.hmpps-probation-production,
    aws_organizations_account.probation-management-non-prod,
    aws_organizations_account.alfresco-non-prod,
    aws_organizations_account.delius-core-non-prod,
    aws_organizations_account.delius-new-tech-non-prod,
    aws_organizations_account.vcms-non-prod,
    aws_organizations_account.probation,
    aws_organizations_account.network-architecture,
    aws_organizations_account.youth-justice-framework-dev,
    aws_organizations_account.youth-justice-framework-management,
    aws_organizations_account.youth-justice-framework-pre-prod,
    aws_organizations_account.youth-justice-framework-juniper,
    aws_organizations_account.youth-justice-framework-prod,
    aws_organizations_account.youth-justice-framework-monitoring,
    aws_organizations_account.youth-justice-framework-eng-tools,
    aws_organizations_account.youth-justice-framework-sandpit,
  ]
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
    aws_organizations_account.electronic-monitoring-acquisitive-crime-development,
    aws_organizations_account.electronic-monitoring-acquisitive-crime-preproduction,
    aws_organizations_account.electronic-monitoring-acquisitive-crime-production,
    aws_organizations_account.electronic-monitoring-acquisitive-crime-test,
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
    aws_organizations_account.hmcts-fee-remissions,
    aws_organizations_account.hmpps-check-my-diary-development,
    aws_organizations_account.hmpps-check-my-diary-prod,
    aws_organizations_account.hmpps-co-financing-organisation,
    aws_organizations_account.hmpps-community-rehabilitation-jira-non-production,
    aws_organizations_account.hmpps-community-rehabilitation-jira-production,
    aws_organizations_account.hmpps-community-rehabilitation-jitbit-non-production,
    aws_organizations_account.hmpps-community-rehabilitation-jitbit-production,
    aws_organizations_account.hmpps-community-rehabilitation-unpaid-work-non-production,
    aws_organizations_account.hmpps-community-rehabilitation-unpaid-work-production,
    aws_organizations_account.hmpps-delius-po-test,
    aws_organizations_account.hmpps-dev,
    aws_organizations_account.hmpps-management,
    aws_organizations_account.hmpps-performance-hub,
    aws_organizations_account.hmpps-prod,
    aws_organizations_account.hmpps-security-poc,
    aws_organizations_account.laa-cloudtrail,
    aws_organizations_account.laa-development,
    aws_organizations_account.laa-production,
    aws_organizations_account.laa-shared-services,
    aws_organizations_account.laa-staging,
    aws_organizations_account.laa-test,
    aws_organizations_account.laa-uat,
    aws_organizations_account.legal-aid-agency,
    aws_organizations_account.manchester-traffic-dev,
    aws_organizations_account.ministry-of-justice-courtfinder-prod,
    aws_organizations_account.modernisation-platform,
    aws_organizations_account.moj-analytics-platform,
    aws_organizations_account.moj-cla,
    aws_organizations_account.moj-digital-services,
    aws_organizations_account.moj-info-services-dev,
    aws_organizations_account.moj-lpa-development,
    aws_organizations_account.moj-lpa-preproduction,
    aws_organizations_account.moj-official-development,
    aws_organizations_account.moj-official-network-operations-centre,
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
    aws_organizations_account.noms-api,
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
    aws_organizations_account.platforms-non-production,
    aws_organizations_account.public-sector-prison-industries,
    aws_organizations_account.security-engineering,
    aws_organizations_account.security-logging-platform,
    aws_organizations_account.security-operations-development,
    aws_organizations_account.security-operations-pre-production,
    aws_organizations_account.security-operations-production,
    aws_organizations_account.tacticalproducts,
    aws_organizations_account.tp-alb,
    aws_organizations_account.tp-hmcts,
    aws_organizations_account.tp-hq,
    aws_organizations_account.workplace-tech-proof-of-concept-development,
    aws_organizations_account.wptpoc
  ], local.enrolled_into_guardduty_non_eu_west_2_only, local.modernisation-platform-managed-account-ids)
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

  # Automatically enable GuardDuty for us-east-1
  auto_enable = true

  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  enrolled_into_guardduty = {
    for account in local.enrolled_into_guardduty :
    account.name => account.id
  }

  filterable_security_accounts = [aws_organizations_account.security-operations-development.id]

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

  # Automatically enable GuardDuty for us-east-2
  auto_enable = true

  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  enrolled_into_guardduty = {
    for account in local.enrolled_into_guardduty :
    account.name => account.id
  }

  filterable_security_accounts = [aws_organizations_account.security-operations-development.id]

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

  # Automatically enable GuardDuty for us-west-1
  auto_enable = true

  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  enrolled_into_guardduty = {
    for account in local.enrolled_into_guardduty :
    account.name => account.id
  }

  filterable_security_accounts = [aws_organizations_account.security-operations-development.id]

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

  # Automatically enable GuardDuty for us-west-2
  auto_enable = true

  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  enrolled_into_guardduty = {
    for account in local.enrolled_into_guardduty :
    account.name => account.id
  }

  filterable_security_accounts = [aws_organizations_account.security-operations-development.id]

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

  # Automatically enable GuardDuty for ap-south-1
  auto_enable = true

  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  filterable_security_accounts = [aws_organizations_account.security-operations-development.id]

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

  # Automatically enable GuardDuty for ap-northeast-2
  auto_enable = true

  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  filterable_security_accounts = [aws_organizations_account.security-operations-development.id]

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

  # Automatically enable GuardDuty for ap-southeast-1
  auto_enable = true

  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  filterable_security_accounts = [aws_organizations_account.security-operations-development.id]

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

  # Automatically enable GuardDuty for ap-southeast-2
  auto_enable = true

  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  filterable_security_accounts = [aws_organizations_account.security-operations-development.id]

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

  # Automatically enable GuardDuty for ap-northeast-1
  auto_enable = true

  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  filterable_security_accounts = [aws_organizations_account.security-operations-development.id]

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

  # Automatically enable GuardDuty for ca-central-1
  auto_enable = true

  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  filterable_security_accounts = [aws_organizations_account.security-operations-development.id]

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

  filterable_security_accounts = [aws_organizations_account.security-operations-development.id]

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

  filterable_security_accounts = [aws_organizations_account.security-operations-development.id]

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
    if !contains(local.enrolled_into_guardduty_non_eu_west_2_only, account)
  }

  filterable_security_accounts = [aws_organizations_account.security-operations-development.id]

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

  filterable_security_accounts = [aws_organizations_account.security-operations-development.id]

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

  filterable_security_accounts = [aws_organizations_account.security-operations-development.id]

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

  # Automatically enable GuardDuty for sa-east-1
  auto_enable = true

  destination_arn = aws_s3_bucket.guardduty-bucket.arn
  kms_key_arn     = aws_kms_key.guardduty.arn

  filterable_security_accounts = [aws_organizations_account.security-operations-development.id]

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
