locals {
  teams_to_account_assignments = [
    # OPG
    {
      github_team    = "opg"
      permission_set = aws_ssoadmin_permission_set.opg-viewer,
      accounts = [
        aws_organizations_account.moj-opg-identity,
        aws_organizations_account.moj-opg-shared-production,
        aws_organizations_account.moj-opg-management,
        aws_organizations_account.moj-opg-shared-development,
        aws_organizations_account.moj-opg-sandbox
      ]
    },
    {
      github_team    = "opg-secops",
      permission_set = aws_ssoadmin_permission_set.opg-security-audit,
      accounts = [
        aws_organizations_account.moj-lpa-development,
        aws_organizations_account.moj-lpa-preproduction,
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
        aws_organizations_account.opg-backups,
        aws_organizations_account.opg-digi-deps-dev,
        aws_organizations_account.opg-digi-deps-preprod,
        aws_organizations_account.opg-digi-deps-prod,
        aws_organizations_account.opg-lpa-production,
        aws_organizations_account.opg-refund-develop,
        aws_organizations_account.opg-refund-production,
        aws_organizations_account.opg-sirius-backup,
        aws_organizations_account.opg-sirius-dev,
        aws_organizations_account.opg-sirius-production,
        aws_organizations_account.opg-use-my-lpa-development,
        aws_organizations_account.opg-use-my-lpa-preproduction,
        aws_organizations_account.opg-use-my-lpa-production
      ]
    },
    # organisation-security
    {
      github_team    = "organisation-security-auditor"
      permission_set = aws_ssoadmin_permission_set.security-audit,
      accounts = [
        aws_organizations_account.organisation-security
      ]
    },
    # Security Operations
    {
      github_team    = "secops"
      permission_set = aws_ssoadmin_permission_set.administrator-access
      accounts = [
        aws_organizations_account.security-operations-development,
        aws_organizations_account.security-operations-pre-production,
        aws_organizations_account.security-operations-production
      ]
    },
    # Cloud Platform (Webops) access
    {
      github_team    = "webops"
      permission_set = aws_ssoadmin_permission_set.administrator-access
      accounts = [
        aws_organizations_account.moj-digital-services
      ]
    }
  ]
  teams_to_account_assignments_association_list = flatten([
    for assignment in local.teams_to_account_assignments : [
      for account in assignment.accounts : {
        account        = account
        github_team    = assignment["github_team"]
        permission_set = assignment["permission_set"]
      }
    ]
  ])
  teams_to_account_assignments_with_keys = {
    for item in local.teams_to_account_assignments_association_list :
    "${item.account.name}-${item.github_team}-${item.permission_set.name}" => item
  }
}

resource "aws_ssoadmin_account_assignment" "account-assignments" {
  for_each = tomap(local.teams_to_account_assignments_with_keys)

  # Instance
  instance_arn = local.sso_instance_arn

  # Permission set to give
  permission_set_arn = each.value.permission_set.arn

  # GitHub team to give the permission set to
  principal_id   = data.aws_identitystore_group.groups[each.value.github_team].group_id
  principal_type = "GROUP"

  # Account ID to give the group permission to access
  target_id   = each.value.account.id
  target_type = "AWS_ACCOUNT"
}
