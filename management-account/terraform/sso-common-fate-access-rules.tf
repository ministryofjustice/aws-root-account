locals {
  common_fate_access_rules = [
    {
      name                    = "data-platform-development-AdministratorAccess"
      description             = "AdministratorAccess to data-platform-development"
      requesting_github_teams = ["data-platform-core-infra"],
      approving_github_teams  = ["data-platform-core-infra"],
      account_ids             = ["013433889002"],
      permission_set_arn      = aws_ssoadmin_permission_set.administrator_access.arn
      duration                = "28800"
    }
  ]
}

resource "commonfate_access_rule" "access_rules" {
  for_each = { for access_rule in local.common_fate_access_rules : access_rule.name => access_rule }

  name        = each.value.name
  description = each.value.description
  groups      = each.value.requesting_github_teams
  approval = {
    groups = each.value.approving_github_teams
  }
  target = [
    {
      field = "accountId"
      value = each.value.account_ids
    },
    {
      field = "permissionSetArn"
      value = [each.value.permission_set_arn]
    }
  ]

  duration           = each.value.duration
  target_provider_id = "aws-sso-v2"
}
