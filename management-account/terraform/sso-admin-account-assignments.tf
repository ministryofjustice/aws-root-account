locals {
  sso_admin_account_assignments = [
    {
      github_team        = "analytics-hq",
      permission_set_arn = aws_ssoadmin_permission_set.ap_read_only_access.arn,
      account_ids = [
        aws_organizations_account.analytical_platform_data_engineering.id,
        aws_organizations_account.analytical_platform_data_engineering_sandbox.id,
        aws_organizations_account.analytical_platform_development.id,
        aws_organizations_account.analytical_platform_landing.id,
        aws_organizations_account.analytical_platform_production.id,
        aws_organizations_account.moj_analytics_platform.id,
      ]
    }
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
