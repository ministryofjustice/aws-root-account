# Accounts to enrol from the AWS Organization
#
# The configuration for the publishing destination is in guardduty_publishing-destination.tf,
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
  source = "../../modules/guardduty-root"

  providers = {
    aws.root_account            = aws.us-east-1
    aws.delegated_administrator = aws.organisation-security-us-east-1
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })
}

module "guardduty_us_east_2" {
  source = "../../modules/guardduty-root"

  providers = {
    aws.root_account            = aws.us-east-2
    aws.delegated_administrator = aws.organisation-security-us-east-2
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })
}

module "guardduty_us_west_1" {
  source = "../../modules/guardduty-root"

  providers = {
    aws.root_account            = aws.us-west-1
    aws.delegated_administrator = aws.organisation-security-us-west-1
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })
}

module "guardduty_us_west_2" {
  source = "../../modules/guardduty-root"

  providers = {
    aws.root_account            = aws.us-west-2
    aws.delegated_administrator = aws.organisation-security-us-west-2
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })
}

###########################
# GuardDuty in AP regions #
###########################
module "guardduty_ap_south_1" {
  source = "../../modules/guardduty-root"

  providers = {
    aws.root_account            = aws.ap-south-1
    aws.delegated_administrator = aws.organisation-security-ap-south-1
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })
}

module "guardduty_ap_northeast_3" {
  source = "../../modules/guardduty-root"

  providers = {
    aws.root_account            = aws.ap-northeast-3
    aws.delegated_administrator = aws.organisation-security-ap-northeast-3
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })
}

module "guardduty_ap_northeast_2" {
  source = "../../modules/guardduty-root"

  providers = {
    aws.root_account            = aws.ap-northeast-2
    aws.delegated_administrator = aws.organisation-security-ap-northeast-2
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })
}

module "guardduty_ap_southeast_1" {
  source = "../../modules/guardduty-root"

  providers = {
    aws.root_account            = aws.ap-southeast-1
    aws.delegated_administrator = aws.organisation-security-ap-southeast-1
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })
}

module "guardduty_ap_southeast_2" {
  source = "../../modules/guardduty-root"

  providers = {
    aws.root_account            = aws.ap-southeast-2
    aws.delegated_administrator = aws.organisation-security-ap-southeast-2
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })
}

module "guardduty_ap_northeast_1" {
  source = "../../modules/guardduty-root"

  providers = {
    aws.root_account            = aws.ap-northeast-1
    aws.delegated_administrator = aws.organisation-security-ap-northeast-1
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })
}

###########################
# GuardDuty in CA regions #
###########################
module "guardduty_ca_central_1" {
  source = "../../modules/guardduty-root"

  providers = {
    aws.root_account            = aws.ca-central-1
    aws.delegated_administrator = aws.organisation-security-ca-central-1
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })
}

###########################
# GuardDuty in EU regions #
###########################
module "guardduty_eu_central_1" {
  source = "../../modules/guardduty-root"

  providers = {
    aws.root_account            = aws.eu-central-1
    aws.delegated_administrator = aws.organisation-security-eu-central-1
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })
}

module "guardduty_eu_central_2" {
  source = "../../modules/guardduty-root"

  providers = {
    aws.root_account            = aws.eu-central-2
    aws.delegated_administrator = aws.organisation-security-eu-central-2
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })
}

module "guardduty_eu_west_1" {
  source = "../../modules/guardduty-root"

  providers = {
    aws.root_account            = aws.eu-west-1
    aws.delegated_administrator = aws.organisation-security-eu-west-1
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })
}

module "guardduty_eu_west_2" {
  source = "../../modules/guardduty-root"

  providers = {
    aws.root_account            = aws.eu-west-2
    aws.delegated_administrator = aws.organisation-security-eu-west-2
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })
}

module "guardduty_eu_west_3" {
  source = "../../modules/guardduty-root"

  providers = {
    aws.root_account            = aws.eu-west-3
    aws.delegated_administrator = aws.organisation-security-eu-west-3
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })
}

module "guardduty_eu_north_1" {
  source = "../../modules/guardduty-root"

  providers = {
    aws.root_account            = aws.eu-north-1
    aws.delegated_administrator = aws.organisation-security-eu-north-1
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })
}

###########################
# GuardDuty in SA regions #
###########################
module "guardduty_sa_east_1" {
  source = "../../modules/guardduty-root"

  providers = {
    aws.root_account            = aws.sa-east-1
    aws.delegated_administrator = aws.organisation-security-sa-east-1
  }

  root_tags = local.root_account
  administrator_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })
}
