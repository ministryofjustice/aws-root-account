locals {
  organisation_security_account_id = coalesce([
    for account in data.aws_organizations_organization.default.accounts :
    account.id
    if account.name == "organisation-security"
  ]...)

  # AWS Organizational Units
  ou_opg = coalesce([
    for ou in data.aws_organizations_organizational_units.organizational_units.children :
    ou.id
    if ou.name == "OPG"
  ]...)

  ou_opg_make_an_lpa = coalesce([
    for ou in data.aws_organizations_organizational_units.opg.children :
    ou.id
    if ou.name == "Make An LPA"
  ]...)

  ou_opg_digideps = coalesce([
    for ou in data.aws_organizations_organizational_units.opg.children :
    ou.id
    if ou.name == "DigiDeps"
  ]...)

  ou_opg_use_my_lpa = coalesce([
    for ou in data.aws_organizations_organizational_units.opg.children :
    ou.id
    if ou.name == "Use My LPA"
  ]...)

  ou_sirius = coalesce([
    for ou in data.aws_organizations_organizational_units.opg.children :
    ou.id
    if ou.name == "Sirius"
  ]...)

  ou_platforms_and_architecture_id = coalesce([
    for ou in data.aws_organizations_organizational_units.organizational_units.children :
    ou.id
    if ou.name == "Platforms & Architecture"
  ]...)

  ou_modernisation_platform_id = coalesce([
    for ou in data.aws_organizations_organizational_units.platforms_and_architecture.children :
    ou.id
    if ou.name == "Modernisation Platform"
  ]...)

  ou_modernisation_platform_core_id = coalesce([
    for ou in data.aws_organizations_organizational_units.modernisation_platform.children :
    ou.id
    if ou.name == "Modernisation Platform Core"
  ]...)

  ou_modernisation_platform_member_id = coalesce([
    for ou in data.aws_organizations_organizational_units.modernisation_platform.children :
    ou.id
    if ou.name == "Modernisation Platform Member"
  ]...)

  ou_modernisation_platform_unrestricted_id = coalesce([
    for ou in data.aws_organizations_organizational_units.modernisation_platform.children :
    ou.id
    if ou.name == "Modernisation Platform Member Unrestricted"
  ]...)

  ou_technology_services = coalesce([
    for ou in data.aws_organizations_organizational_units.organizational_units.children :
    ou.id
    if ou.name == "Technology Services"
  ]...)

  ou_laa = coalesce([
    for ou in data.aws_organizations_organizational_units.organizational_units.children :
    ou.id
    if ou.name == "LAA"
  ]...)

  # Shield Advanced
  shield_advanced_auto_remediate = {
    accounts = [
      for account_name, account_value in local.accounts.active_only_not_self :
      account_value
      if
      (
        account_name == "Legal Aid Agency" ||
        account_name == "LAA Development" ||
        account_name == "Youth Justice Framework Dev" ||
        account_name == "Youth Justice Framework Eng Tools" ||
        account_name == "Youth Justice Framework Management" ||
        account_name == "Youth Justice Framework Sandpit"
      )
    ],
    organizational_units = flatten([
      local.ou_opg_make_an_lpa,
      local.ou_opg_use_my_lpa,
      local.ou_sirius,
      local.ou_technology_services,
      data.aws_organizations_organizational_units.modernisation_platform_core.id,
      data.aws_organizations_organizational_units.modernisation_platform_member.id
    ])
  }
  shield_advanced_no_auto_remediate = {
    accounts = [
      for account_name, account_value in local.accounts.active_only_not_self :
      account_value
      if
      (
        account_name == "shared-services-dev" ||
        account_name == "MoJ Digital Services"
      )
    ],
    organizational_units = [
      local.ou_laa,
      local.ou_opg_digideps,
    ]
  }

  # Accounts map
  accounts = {
    active_only_not_self : {
      for account in data.aws_organizations_organization.default.accounts :
      account.name => account.id
      if account.status == "ACTIVE" && account.name != "organisation-security"
    }
  }
}
