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
    aws_organizations_account.hmpps-delius-mis-test.id,
    aws_organizations_account.hmpps-delius-po-test-2.id,
    aws_organizations_account.hmpps-delius-po-test-1.id,
    aws_organizations_account.hmpps-delius-training-test.id,
    aws_organizations_account.hmpps-delius-training.id,
    aws_organizations_account.hmpps-delius-mis-non-prod.id,
    aws_organizations_account.hmpps-victim-case-management-system-performance.id,
    aws_organizations_account.hmpps-victim-case-management-system-stage.id,
    aws_organizations_account.hmpps-victim-case-management-system-test.id,
    aws_organizations_account.hmpps-security-audit.id,
    aws_organizations_account.hmpps-engineering-production.id,
    aws_organizations_account.hmpps-delius-pre-production.id,
    aws_organizations_account.hmpps-delius-performance.id,
    aws_organizations_account.hmpps-delius-stage.id,
    aws_organizations_account.hmpps-delius-test.id,
    aws_organizations_account.hmpps-victim-case-management-system-pre-production.id,
    aws_organizations_account.hmpps-victim-case-management-system-production.id,
    aws_organizations_account.hmpps-victim-case-management-system-integration.id,
    aws_organizations_account.strategic-partner-gateway-non-production.id,
    aws_organizations_account.hmpps-probation-production.id,
    aws_organizations_account.probation-management-non-prod.id,
    aws_organizations_account.alfresco-non-prod.id,
    aws_organizations_account.delius-core-non-prod.id,
    aws_organizations_account.delius-new-tech-non-prod.id,
    aws_organizations_account.vcms-non-prod.id,
    aws_organizations_account.probation.id,
    aws_organizations_account.network-architecture.id,
    aws_organizations_account.youth-justice-framework-management.id,
    aws_organizations_account.youth-justice-framework-pre-prod.id,
    aws_organizations_account.youth-justice-framework-prod.id,
    aws_organizations_account.youth-justice-framework-monitoring.id
  ]
  enrolled_into_guardduty = {
    for account in aws_organizations_organization.default.accounts :
    account.name => account.id
    # Don't enrol the organisation-security account (as it'll already be enabled as the delegated administrator)
    # Don't enrol suspended or removed (i.e. deleted) accounts
    if account.status == "ACTIVE" && account.name != "organisation-security"
  }
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

  # Enrol accounts created prior to the auto_enable flag being set
  enrolled_into_guardduty = local.enrolled_into_guardduty

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

module "guardduty-us-east-2" {
  source = "./modules/guardduty"

  providers = {
    aws.root-account            = aws.aws-root-account-us-east-2
    aws.delegated-administrator = aws.organisation-security-us-east-2
  }

  # Automatically enable GuardDuty for us-east-2
  auto_enable = true

  # Enrol accounts created prior to the auto_enable flag being set
  enrolled_into_guardduty = local.enrolled_into_guardduty

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

module "guardduty-us-west-1" {
  source = "./modules/guardduty"

  providers = {
    aws.root-account            = aws.aws-root-account-us-west-1
    aws.delegated-administrator = aws.organisation-security-us-west-1
  }

  # Automatically enable GuardDuty for us-west-1
  auto_enable = true

  # Enrol accounts created prior to the auto_enable flag being set
  enrolled_into_guardduty = local.enrolled_into_guardduty

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

module "guardduty-us-west-2" {
  source = "./modules/guardduty"

  providers = {
    aws.root-account            = aws.aws-root-account-us-west-2
    aws.delegated-administrator = aws.organisation-security-us-west-2
  }

  # Automatically enable GuardDuty for us-west-2
  auto_enable = true

  # Enrol accounts created prior to the auto_enable flag being set
  enrolled_into_guardduty = local.enrolled_into_guardduty

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

  # Enrol accounts created prior to the auto_enable flag being set
  enrolled_into_guardduty = local.enrolled_into_guardduty

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

module "guardduty-ap-northeast-3" {
  source = "./modules/guardduty"

  providers = {
    aws.root-account            = aws.aws-root-account-ap-northeast-3
    aws.delegated-administrator = aws.organisation-security-ap-northeast-3
  }

  # Automatically enable GuardDuty for ap-northeast-3
  auto_enable = true

  # Enrol accounts created prior to the auto_enable flag being set
  enrolled_into_guardduty = local.enrolled_into_guardduty

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

  # Enrol accounts created prior to the auto_enable flag being set
  enrolled_into_guardduty = local.enrolled_into_guardduty

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

  # Enrol accounts created prior to the auto_enable flag being set
  enrolled_into_guardduty = local.enrolled_into_guardduty

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

  # Enrol accounts created prior to the auto_enable flag being set
  enrolled_into_guardduty = local.enrolled_into_guardduty

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

  # Enrol accounts created prior to the auto_enable flag being set
  enrolled_into_guardduty = local.enrolled_into_guardduty

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

  # Enrol accounts created prior to the auto_enable flag being set
  enrolled_into_guardduty = local.enrolled_into_guardduty

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

  # Automatically enable GuardDuty for eu-central-1
  auto_enable = true

  # Enrol accounts created prior to the auto_enable flag being set
  enrolled_into_guardduty = local.enrolled_into_guardduty

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

module "guardduty-eu-west-1" {
  source = "./modules/guardduty"

  providers = {
    aws.root-account            = aws.aws-root-account-eu-west-1
    aws.delegated-administrator = aws.organisation-security-eu-west-1
  }

  # Automatically enable GuardDuty for eu-west-1
  auto_enable = true

  # Enrol accounts created prior to the auto_enable flag being set
  enrolled_into_guardduty = local.enrolled_into_guardduty

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

module "guardduty-eu-west-2" {
  source = "./modules/guardduty"

  providers = {
    aws.root-account            = aws.aws-root-account-eu-west-2
    aws.delegated-administrator = aws.organisation-security-eu-west-2
  }

  # Automatically enable GuardDuty for eu-west-2
  auto_enable = true

  enrolled_into_guardduty = {
    for account_name, account_id in local.enrolled_into_guardduty :
    account_name => account_id
    if !contains(local.enrolled_into_guardduty_non_eu_west_2_only, account_id)
  }

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

module "guardduty-eu-west-3" {
  source = "./modules/guardduty"

  providers = {
    aws.root-account            = aws.aws-root-account-eu-west-3
    aws.delegated-administrator = aws.organisation-security-eu-west-3
  }

  # Automatically enable GuardDuty for eu-west-3
  auto_enable = true

  # Enrol accounts created prior to the auto_enable flag being set
  enrolled_into_guardduty = local.enrolled_into_guardduty

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

module "guardduty-eu-north-1" {
  source = "./modules/guardduty"

  providers = {
    aws.root-account            = aws.aws-root-account-eu-north-1
    aws.delegated-administrator = aws.organisation-security-eu-north-1
  }

  # Automatically enable GuardDuty for eu-north-1
  auto_enable = true

  # Enrol accounts created prior to the auto_enable flag being set
  enrolled_into_guardduty = local.enrolled_into_guardduty

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

  # Enrol accounts created prior to the auto_enable flag being set
  enrolled_into_guardduty = local.enrolled_into_guardduty

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
