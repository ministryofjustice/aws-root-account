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

  # Account maps
  accounts = {
    active_only : {
      for account in aws_organizations_organization.default.accounts :
      account.name => account.id
      if account.status == "ACTIVE"
    }
  }

  # Modernisation Platform account IDs
  modernisation_platform_accounts = {
    core_network_services_id = [
      for account_name, account_id in local.accounts.active_only :
      account_id
      if account_name == "core-network-services"
    ]
    core_shared_services_id = [
      for account_name, account_id in local.accounts.active_only :
      account_id
      if account_name == "core-shared-services"
    ]
    modernisation_platform_id = [
      for account_name, account_id in local.accounts.active_only :
      account_id
      if account_name == "Modernisation Platform"
    ]
  }

  root_account = merge(local.tags_business_units.platforms, {
    application   = "AWS root account"
    is-production = true
    owner         = "Hosting Leads: hosting-leads@digital.justice.gov.uk"
  })

  tags_organisation_management = {
    application            = "Organisation Management"
    business-unit          = "Platforms"
    infrastructure-support = "Hosting Leads: hosting-leads@digital.justice.gov.uk"
    is-production          = true
    owner                  = "Hosting Leads: hosting-leads@digital.justice.gov.uk"
    source-code            = "github.com/ministryofjustice/aws-root-account"
  }

  # SSO
  sso = {
    email_suffix        = "@digital.justice.gov.uk"
    region              = "eu-west-2"
    github_organisation = "ministryofjustice"
    auth0_tenant_domain = "ministryofjustice.eu.auth0.com"
    auth0_saml          = sensitive(jsondecode(data.aws_secretsmanager_secret_version.auth0_saml.secret_string))
    github_saml         = sensitive(jsondecode(data.aws_secretsmanager_secret_version.github_saml.secret_string))
    aws_saml            = sensitive(jsondecode(data.aws_secretsmanager_secret_version.aws_saml.secret_string))
    azure_entraid_oidc  = sensitive(jsondecode(data.aws_secretsmanager_secret_version.azure_entraid_oidc.secret_string))
  }

  # Cost allocation tags
  cost_allocation_tags = toset([
    "eks:eks-cluster-name",
    "karpenter.k8s.aws/ec2nodeclass",
    "karpenter.sh/nodeclaim",
    "karpenter.sh/nodepool"
  ])
}
