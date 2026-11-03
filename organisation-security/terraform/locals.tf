locals {

  excluded_accounts = ["organisation-security", "xhibit-portal-production"]

  organizations_organization = data.terraform_remote_state.management_account.outputs.organizations_organization

  root_account_id = coalesce([
    for account in local.organizations_organization.accounts :
    account.id
    if account.name == "MOJ Master"
  ]...)

  organisation_security_account_id = coalesce([
    for account in local.organizations_organization.accounts :
    account.id
    if account.name == "organisation-security"
  ]...)

  moj_network_operations_centre_preproduction_account_id = coalesce([
    for account in local.organizations_organization.accounts :
    account.id
    if account.name == "moj-network-operations-centre-preproduction"
  ]...)

  moj_network_operations_centre_production_account_id = coalesce([
    for account in local.organizations_organization.accounts :
    account.id
    if account.name == "moj-network-operations-centre-production"
  ]...)

  cloud_platform_account_id = coalesce([
    for account in local.organizations_organization.accounts :
    account.id
    if account.name == "Cloud Platform"
  ]...)

  organisation_account_numbers = [for account in local.organizations_organization.accounts : account.id]

  # AWS Organizational Units
  ## Central Digital
  ou_central_digital_id = coalesce([
    for ou in data.aws_organizations_organizational_units.organizational_units.children :
    ou.id
    if ou.name == "Central Digital"
  ]...)

  ## Criminal Injuries Compensation Authority
  ou_cica_id = coalesce([
    for ou in data.aws_organizations_organizational_units.organizational_units.children :
    ou.id
    if ou.name == "CICA"
  ]...)

  ## HM Courts & Tribunal Service
  ou_hmcts_id = coalesce([
    for ou in data.aws_organizations_organizational_units.organizational_units.children :
    ou.id
    if ou.name == "HMCTS"
  ]...)

  ## HM Prison and Probation Service
  ou_hmpps_id = coalesce([
    for ou in data.aws_organizations_organizational_units.organizational_units.children :
    ou.id
    if ou.name == "HMPPS"
  ]...)

  ## Legal Aid Agency
  ou_laa = coalesce([
    for ou in data.aws_organizations_organizational_units.organizational_units.children :
    ou.id
    if ou.name == "LAA"
  ]...)

  ## Office of the Public Guardian
  ou_opg = coalesce([
    for ou in data.aws_organizations_organizational_units.organizational_units.children :
    ou.id
    if ou.name == "OPG"
  ]...)

  ou_opg_lpa_data_store = coalesce([
    for ou in data.aws_organizations_organizational_units.opg.children :
    ou.id
    if ou.name == "LPA Data Store"
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

  ## Organisation Management
  ou_organisation_management = coalesce([
    for ou in data.aws_organizations_organizational_units.organizational_units.children :
    ou.id
    if ou.name == "Organisation Management"
  ]...)

  ## Security Engineering
  ou_security_engineering_id = coalesce([
    for ou in data.aws_organizations_organizational_units.organizational_units.children :
    ou.id
    if ou.name == "Security Engineering"
  ]...)

  ## Platforms and Architecture
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

  ## Technology Services
  ou_technology_services = coalesce([
    for ou in data.aws_organizations_organizational_units.organizational_units.children :
    ou.id
    if ou.name == "Technology Services"
  ]...)

  # modernisation_platform_member_ous = [
  #   for ou in data.aws_organizations_organizational_units.modernisation_platform_member.children :
  #   ou.id
  # ]

  ou_modernisation_platform_member_arn = coalesce([
    for ou in data.aws_organizations_organizational_units.modernisation_platform.children :
    ou.arn
    if ou.name == "Modernisation Platform Member"
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
        account_name == "Youth Justice Framework Sandpit" ||
        account_name == "Cloud Platform Ephemeral Test"
      )
    ],
    organizational_units = flatten([
      local.ou_opg_lpa_data_store,
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
      for account in local.organizations_organization.accounts :
      account.name => account.id
      if account.status == "ACTIVE"
      && !contains(local.excluded_accounts, account.name)
    }
  }


  guardduty_administrator_detector_ids = data.terraform_remote_state.management_account.outputs.guardduty_administrator_detector_ids

  # Organisation CloudTrail (S3 delivery, for Wiz)
  # Created from this account as CloudTrail delegated administrator; the management account owns the trail,
  # so its ARN and the AWSLogs/<management account>/ prefix use the management account ID.
  organisation_cloudtrail_name        = "organisation-cloudtrail"
  organisation_cloudtrail_bucket_name = "moj-organisation-cloudtrail"
  organisation_cloudtrail_bucket_arn  = "arn:aws:s3:::${local.organisation_cloudtrail_bucket_name}"
  organisation_cloudtrail_log_prefix  = "AWSLogs/"
  organisation_cloudtrail_kms_alias   = "organisation-cloudtrail"

  # Built from names, not resource attributes, to avoid dependency cycles between the key, bucket, topic and queue policies.
  organisation_cloudtrail_arn           = "arn:aws:cloudtrail:${data.aws_region.current.region}:${local.root_account_id}:trail/${local.organisation_cloudtrail_name}"
  organisation_cloudtrail_sns_topic     = "organisation-cloudtrail"
  organisation_cloudtrail_sns_topic_arn = "arn:aws:sns:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:${local.organisation_cloudtrail_sns_topic}"
  organisation_cloudtrail_wiz_queue     = "wiz-cloudtrail"
  organisation_cloudtrail_wiz_queue_arn = "arn:aws:sqs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:${local.organisation_cloudtrail_wiz_queue}"
  organisation_cloudtrail_wiz_dlq       = "wiz-cloudtrail-dlq"
  organisation_cloudtrail_wiz_policy    = "WizCloudTrailRead"

  # Log retention: GLACIER_IR after 90 days, expire after 365 days
  organisation_cloudtrail_transition_days        = 90
  organisation_cloudtrail_expiration_days        = 365
  organisation_cloudtrail_noncurrent_expiry_days = 30
  organisation_cloudtrail_sqs_retention_seconds  = 1209600 # 14 days
  organisation_cloudtrail_sqs_visibility_seconds = 300
  organisation_cloudtrail_sqs_max_receive_count  = 5

  organisation_cloudtrail_tags = merge(
    local.tags_organisation_management, {
      component = "Security"
    }
  )
}
