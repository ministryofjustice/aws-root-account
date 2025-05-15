locals {
  sso_admin_account_assignments = [
    {
      github_team        = "aws-root-account-admin-team",
      permission_set_arn = aws_ssoadmin_permission_set.read_only_access.arn,
      account_ids = [
        aws_organizations_organization.default.master_account_id,
        aws_organizations_account.organisation_security.id,
        aws_organizations_account.organisation_logging.id,
      ]
    },
    {
      github_team        = "aws-root-account-admin-team",
      permission_set_arn = aws_ssoadmin_permission_set.administrator_access.arn,
      account_ids = [
        aws_organizations_organization.default.master_account_id,
        aws_organizations_account.organisation_security.id,
      ]
    },
    {
      github_team        = "aws-root-account-admin-team",
      permission_set_arn = aws_ssoadmin_permission_set.aws_sso_read_only.arn,
      account_ids = [
        aws_organizations_organization.default.master_account_id,
        aws_organizations_account.organisation_security.id,
      ]
    },
    {
      github_team        = "aws-root-account-admin-team",
      permission_set_arn = aws_ssoadmin_permission_set.security_audit.arn,
      account_ids = [
        aws_organizations_organization.default.master_account_id
      ]
    },
    {
      github_team        = "aws-root-account-admin-team",
      permission_set_arn = aws_ssoadmin_permission_set.view_only_access.arn,
      account_ids = [
        aws_organizations_organization.default.master_account_id
      ]
    },
    {
      github_team        = "aws-root-account-admin-team",
      permission_set_arn = aws_ssoadmin_permission_set.billing.arn,
      account_ids = [
        aws_organizations_organization.default.master_account_id
      ]
    },
    {
      github_team        = "webops",
      permission_set_arn = aws_ssoadmin_permission_set.administrator_access.arn,
      account_ids = [
        aws_organizations_account.cloud_platform_ephemeral_test.id,
      ]
    },
    {
      github_team        = "cloud-platform-engineers",
      permission_set_arn = aws_ssoadmin_permission_set.administrator_access.arn,
      account_ids = [
        aws_organizations_account.cloud_platform.id,
      ]
    },
    {
      github_team        = "webops",
      permission_set_arn = aws_ssoadmin_permission_set.read_only_access.arn,
      account_ids = [
        aws_organizations_account.cloud_platform.id,
      ]
    },
    {
      github_team        = "webops",
      permission_set_arn = aws_ssoadmin_permission_set.billing.arn,
      account_ids = [
        aws_organizations_account.cloud_platform.id,
      ]
    },
    {
      github_team        = "operations-engineering",
      permission_set_arn = aws_ssoadmin_permission_set.administrator_access.arn,
      account_ids = [
        aws_organizations_account.moj_digital_services.id,
        aws_organizations_account.tacticalproducts.id,
        aws_organizations_account.youth_justice_framework_management.id
      ]
    },
    {
      github_team        = "operations-engineering",
      permission_set_arn = aws_ssoadmin_permission_set.read_only_access.arn,
      account_ids = [
        aws_organizations_account.moj_digital_services.id,
        aws_organizations_organization.default.master_account_id
      ]
    },
    {
      github_team        = "cica",
      permission_set_arn = aws_ssoadmin_permission_set.administrator_access.arn,
      account_ids = [
        aws_organizations_account.cica_development.id,
        aws_organizations_account.cica_production.id,
        aws_organizations_account.cica_shared_services.id,
        aws_organizations_account.cica_uat.id
      ]
    },
    {
      github_team        = "hmpps-migration",
      permission_set_arn = aws_ssoadmin_permission_set.read_only_access.arn,
      account_ids = [
        aws_organizations_account.hmpps_cr_jira_production.id,
        aws_organizations_account.hmpps_cr_unpaid_work_non_production.id,
        aws_organizations_account.hmpps_cr_unpaid_work_production.id,
        aws_organizations_account.alfresco_non_prod.id,
        aws_organizations_account.hmpps_delius_mis_non_prod.id,
        aws_organizations_account.hmpps_delius_pre_production.id,
        aws_organizations_account.hmpps_delius_stage.id,
        aws_organizations_account.hmpps_delius_test.id,
        aws_organizations_account.hmpps_delius_training.id,
        aws_organizations_account.probation_management_non_prod.id,
        aws_organizations_account.hmpps_victim_case_management_system_pre_production.id,
        aws_organizations_account.hmpps_victim_case_management_system_production.id,
        aws_organizations_account.hmpps_victim_case_management_system_test.id,
        aws_organizations_account.vcms_non_prod.id,
        aws_organizations_account.hmpps_engineering_production.id,
        aws_organizations_account.hmpps_probation_production.id,
        aws_organizations_account.probation.id,
      ]
    },
    {
      github_team        = "hmpps-jenkins-admin",
      permission_set_arn = aws_ssoadmin_permission_set.administrator_access.arn,
      account_ids = [
        aws_organizations_account.hmpps_cr_jira_production.id,
        aws_organizations_account.hmpps_cr_unpaid_work_non_production.id,
        aws_organizations_account.hmpps_cr_unpaid_work_production.id,
      ]
    },
    {
      github_team        = "hmpps-ems-team",
      permission_set_arn = aws_ssoadmin_permission_set.administrator_access.arn,
      account_ids = [
        aws_organizations_account.electronic_monitoring_acquisitive_crime_dev.id,
        aws_organizations_account.electronic_monitoring_acquisitive_crime_preprod.id,
        aws_organizations_account.electronic_monitoring_acquisitive_crime_production.id,
        aws_organizations_account.electronic_monitoring_acquisitive_crime_test.id,
        aws_organizations_account.electronic_monitoring_case_management_dev.id,
        aws_organizations_account.electronic_monitoring_case_management_preprod.id,
        aws_organizations_account.electronic_monitoring_case_management_prod.id,
        aws_organizations_account.electronic_monitoring_identity_and_access_management.id,
        aws_organizations_account.electronic_monitoring_infrastructure_dev.id,
        aws_organizations_account.electronic_monitoring_monitoring_and_mapping_dev.id,
        aws_organizations_account.electronic_monitoring_case_management_networking_prod.id,
        aws_organizations_account.electronic_monitoring_case_management_management_prod.id,
        aws_organizations_account.electronic_monitoring_protective_monitoring.id,
        aws_organizations_account.electronic_monitoring_shared_logging.id,
        aws_organizations_account.electronic_monitoring_shared_networking.id,
        aws_organizations_account.electronic_monitoring_shared_networking_non_prod.id,
        aws_organizations_account.electronic_monitoring_tagging_hardware_pre_prod.id,
        aws_organizations_account.electronic_monitoring_tagging_hardware_prod.id,
        aws_organizations_account.electronic_monitoring_tagging_hardware_test.id,
      ]
    },
    {
      github_team        = "hmpps-ems-moj-soc",
      permission_set_arn = aws_ssoadmin_permission_set.security_audit.arn,
      account_ids = [
        aws_organizations_account.electronic_monitoring_shared_logging.id,
      ]
    },
    {
      github_team        = "opg-secops",
      permission_set_arn = aws_ssoadmin_permission_set.opg_security_audit.arn,
      account_ids = [
        aws_organizations_account.moj_opg_digicop_development.id,
        aws_organizations_account.moj_opg_digicop_preproduction.id,
        aws_organizations_account.moj_opg_digicop_production.id,
        aws_organizations_account.opg_digi_deps_dev.id,
        aws_organizations_account.opg_digi_deps_preprod.id,
        aws_organizations_account.opg_digi_deps_prod.id,
        aws_organizations_account.moj_opg_lpa_refunds_development.id,
        aws_organizations_account.moj_opg_lpa_refunds_preproduction.id,
        aws_organizations_account.moj_opg_lpa_refunds_production.id,
        aws_organizations_account.opg_refund_production.id,
        aws_organizations_account.moj_lpa_development.id,
        aws_organizations_account.moj_lpa_preproduction.id,
        aws_organizations_account.moj_opg_lpa_production.id,
        aws_organizations_account.opg_lpa_production.id,
        aws_organizations_account.opg_modernising_lpa_development.id,
        aws_organizations_account.opg_modernising_lpa_preproduction.id,
        aws_organizations_account.opg_modernising_lpa_production.id,
        aws_organizations_account.moj_opg_sirius_preproduction.id,
        aws_organizations_account.opg_sirius_backup.id,
        aws_organizations_account.opg_sirius_production.id,
        aws_organizations_account.opg_sirius_dev.id,
        aws_organizations_account.opg_use_my_lpa_development.id,
        aws_organizations_account.opg_use_my_lpa_preproduction.id,
        aws_organizations_account.opg_use_my_lpa_production.id,
        aws_organizations_account.moj_opg_identity.id,
        aws_organizations_account.moj_opg_management.id,
        aws_organizations_account.moj_opg_sandbox.id,
        aws_organizations_account.moj_opg_shared_development.id,
        aws_organizations_account.moj_opg_shared_production.id,
        aws_organizations_account.opg_backups.id,
      ]
    },
    {
      github_team        = "opg-use-a-lpa-team",
      permission_set_arn = aws_ssoadmin_permission_set.opg_breakglass.arn,
      account_ids = [
        aws_organizations_account.opg_use_my_lpa_development.id,
        aws_organizations_account.opg_use_my_lpa_preproduction.id,
        aws_organizations_account.moj_opg_shared_development.id,
      ]
    },
    {
      github_team        = "opg",
      permission_set_arn = aws_ssoadmin_permission_set.opg_viewer.arn,
      account_ids = [
        aws_organizations_account.opg_use_my_lpa_development.id,
        aws_organizations_account.opg_use_my_lpa_preproduction.id,
        aws_organizations_account.moj_opg_identity.id,
        aws_organizations_account.moj_opg_management.id,
        aws_organizations_account.moj_opg_sandbox.id,
        aws_organizations_account.moj_opg_shared_development.id,
        aws_organizations_account.moj_opg_shared_production.id,
      ]
    },
    {
      github_team        = "opg-use-a-lpa-team",
      permission_set_arn = aws_ssoadmin_permission_set.opg_operator.arn,
      account_ids = [
        aws_organizations_account.opg_use_my_lpa_production.id,
        aws_organizations_account.moj_opg_identity.id,
        aws_organizations_account.moj_opg_management.id,
        aws_organizations_account.moj_opg_shared_production.id,
      ]
    },
    {
      github_team        = "organisation-security-auditor",
      permission_set_arn = aws_ssoadmin_permission_set.security_audit.arn,
      account_ids = [
        aws_organizations_organization.default.master_account_id,
        aws_organizations_account.organisation_security.id,
        aws_organizations_account.cloud_platform.id
      ]
    },
    {
      github_team        = "organisation-security-auditor",
      permission_set_arn = aws_ssoadmin_permission_set.view_only_access.arn,
      account_ids = [
        aws_organizations_account.organisation_security.id,
        aws_organizations_account.cloud_platform.id
      ]
    },
    {
      github_team        = "organisation-security-auditor",
      permission_set_arn = aws_ssoadmin_permission_set.read_only_access.arn,
      account_ids = [
        aws_organizations_account.organisation_security.id,
      ]
    },
    {
      github_team        = "modernisation-platform-engineers",
      permission_set_arn = aws_ssoadmin_permission_set.read_only_access.arn,
      account_ids = [
        aws_organizations_account.moj_official_production.id,
        aws_organizations_account.moj_official_shared_services.id,
        aws_organizations_account.organisation_security.id
      ]
    },
    {
      github_team        = "modernisation-platform",
      permission_set_arn = aws_ssoadmin_permission_set.read_only_access.arn,
      account_ids = [
        aws_organizations_account.modernisation_platform.id
      ]
    },
    {
      github_team        = "modernisation-platform-engineers",
      permission_set_arn = aws_ssoadmin_permission_set.modernisation_platform_engineer.arn,
      account_ids = [
        aws_organizations_account.modernisation_platform.id,
        aws_organizations_organization.default.master_account_id,
        aws_organizations_account.organisation_security.id
      ]
    },
    {
      github_team        = "modernisation-platform-engineers",
      permission_set_arn = aws_ssoadmin_permission_set.administrator_access.arn,
      account_ids = [
        aws_organizations_account.modernisation_platform.id,
        aws_organizations_account.youth_justice_framework_management.id
      ]
    },
    {
      github_team        = "secops",
      permission_set_arn = aws_ssoadmin_permission_set.administrator_access.arn,
      account_ids = [
        aws_organizations_account.security_operations_pre_production.id,
      ]
    },
    {
      github_team        = "nvvs-devops-admins",
      permission_set_arn = aws_ssoadmin_permission_set.administrator_access.arn,
      account_ids = [
        aws_organizations_account.moj_official_development.id,
        aws_organizations_account.moj_official_preproduction.id,
        aws_organizations_account.moj_official_production.id,
        aws_organizations_account.moj_official_public_key_infrastructure_dev.id,
        aws_organizations_account.moj_official_public_key_infrastructure.id,
        aws_organizations_account.moj_official_shared_services.id,
        aws_organizations_account.workplace_tech_proof_of_concept_development.id,
      ]
    },
    {
      github_team        = "eucs-architects",
      permission_set_arn = aws_ssoadmin_permission_set.administrator_access.arn,
      account_ids = [
        aws_organizations_account.moj_official_public_key_infrastructure_dev.id,
        aws_organizations_account.moj_official_public_key_infrastructure.id,
      ]
    },
    {
      github_team        = "moj-official-techops",
      permission_set_arn = aws_ssoadmin_permission_set.administrator_access.arn,
      account_ids = [
        aws_organizations_account.moj_official_development.id,
        aws_organizations_account.workplace_tech_proof_of_concept_development.id,
        aws_organizations_account.network_architecture.id,
      ]
    },
    {
      github_team        = "moj-official-techops",
      permission_set_arn = aws_ssoadmin_permission_set.techops_operator.arn,
      account_ids = [
        aws_organizations_account.moj_official_development.id,
        aws_organizations_account.moj_official_preproduction.id,
        aws_organizations_account.moj_official_production.id,
        aws_organizations_account.moj_official_public_key_infrastructure_dev.id,
        aws_organizations_account.moj_official_public_key_infrastructure.id,
        aws_organizations_account.moj_official_shared_services.id,
        aws_organizations_account.workplace_tech_proof_of_concept_development.id,
        aws_organizations_account.network_architecture.id,
      ]
    },
    {
      github_team        = "moj-official-techops",
      permission_set_arn = aws_ssoadmin_permission_set.read_only_access.arn,
      account_ids = flatten([
        local.modernisation_platform_accounts.core_network_services_id,
        aws_organizations_account.organisation_security.id
      ])
    },
    {
      github_team        = "cloud-ops-alz-admins",
      permission_set_arn = aws_ssoadmin_permission_set.administrator_access.arn,
      account_ids = [
        aws_organizations_account.moj_official_development.id
      ]
    },
    {
      github_team        = "cloud-ops-alz-admins",
      permission_set_arn = aws_ssoadmin_permission_set.read_only_access.arn,
      account_ids = [
        aws_organizations_account.moj_official_preproduction.id,
        aws_organizations_account.moj_official_production.id,
        aws_organizations_account.moj_official_shared_services.id,
      ]
    },
    {
      github_team        = "nvvs-devops-writers",
      permission_set_arn = aws_ssoadmin_permission_set.read_only_access.arn,
      account_ids = [
        aws_organizations_account.moj_official_development.id,
        aws_organizations_account.moj_official_preproduction.id,
        aws_organizations_account.moj_official_production.id,
        aws_organizations_account.moj_official_public_key_infrastructure_dev.id,
        aws_organizations_account.moj_official_public_key_infrastructure.id,
        aws_organizations_account.moj_official_shared_services.id,
      ]
    },
    {
      github_team        = "moj-eucs-identity",
      permission_set_arn = aws_ssoadmin_permission_set.read_only_access.arn,
      account_ids = [
        aws_organizations_account.moj_official_development.id,
        aws_organizations_account.moj_official_preproduction.id,
        aws_organizations_account.moj_official_production.id,
        aws_organizations_account.moj_official_public_key_infrastructure_dev.id,
        aws_organizations_account.moj_official_public_key_infrastructure.id,
        aws_organizations_account.moj_official_shared_services.id,
      ]
    },
    {
      github_team        = "moj-official-sharedservices-noc",
      permission_set_arn = aws_ssoadmin_permission_set.administrator_access.arn,
      account_ids = [
        aws_organizations_account.moj_official_shared_services.id,
      ]
    },
    {
      github_team        = "modernisation-platform-engineers",
      permission_set_arn = aws_ssoadmin_permission_set.aws_sso_read_only.arn,
      account_ids = [
        aws_organizations_organization.default.master_account_id
      ]
    },
    {
      github_team        = "modernisation-platform-engineers",
      permission_set_arn = aws_ssoadmin_permission_set.security_audit.arn,
      account_ids = [
        aws_organizations_organization.default.master_account_id
      ]
    },
    {
      github_team        = "laa-internal-analysis",
      permission_set_arn = aws_ssoadmin_permission_set.security_audit.arn,
      account_ids = [
        aws_organizations_account.organisation_security.id,
        aws_organizations_account.cloud_platform.id
      ]
    },
    {
      github_team        = "modernisation-platform",
      permission_set_arn = aws_ssoadmin_permission_set.security_audit.arn,
      account_ids = [
        aws_organizations_organization.default.master_account_id
      ]
    },
    {
      github_team        = "modernisation-platform-engineers",
      permission_set_arn = aws_ssoadmin_permission_set.view_only_access.arn,
      account_ids = [
        aws_organizations_organization.default.master_account_id
      ]
    },
    {
      github_team        = "modernisation-platform",
      permission_set_arn = aws_ssoadmin_permission_set.billing.arn,
      account_ids = [
        aws_organizations_organization.default.master_account_id
      ]
    },
    {
      github_team        = "organisation-security-waf"
      permission_set_arn = aws_ssoadmin_permission_set.waf_viewer.arn,
      account_ids = [
        aws_organizations_account.organisation_security.id
      ]
    },
    {
      github_team        = "soc-engineering",
      permission_set_arn = aws_ssoadmin_permission_set.read_only_access.arn,
      account_ids = [
        aws_organizations_account.moj_official_development.id
      ]
    },
    {
      github_team        = "aws-sso-admin",
      permission_set_arn = aws_ssoadmin_permission_set.aws_sso_admin.arn,
      account_ids = [
        aws_organizations_organization.default.master_account_id
      ]
    },
    {
      github_team        = "azure-aws-sso-laa-readers",
      permission_set_arn = aws_ssoadmin_permission_set.laa_lz_s3_read_access.arn,
      account_ids = [
        aws_organizations_account.laa_production.id,
      ]
    },
  ]
  sso_admin_account_assignments_expanded = flatten([
    for assignment in local.sso_admin_account_assignments : [
      for account_id in assignment.account_ids : {
        account_id         = account_id,
        github_team        = assignment.github_team,
        permission_set_arn = assignment.permission_set_arn
      }
    ]
  ])
  sso_admin_account_assignments_with_keys = {
    for assignment in local.sso_admin_account_assignments_expanded :
    "${assignment.github_team}-${assignment.account_id}-${assignment.permission_set_arn}" => assignment
  }
}

resource "aws_ssoadmin_account_assignment" "github_team_access" {
  for_each = tomap(local.sso_admin_account_assignments_with_keys)

  instance_arn       = local.sso_admin_instance_arn
  permission_set_arn = each.value.permission_set_arn
  principal_id       = data.aws_identitystore_group.default[each.value.github_team].group_id
  principal_type     = "GROUP"
  target_id          = each.value.account_id
  target_type        = "AWS_ACCOUNT"
}
