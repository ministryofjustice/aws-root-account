# This uses the local.groups_to_account_assignments keys, and looks up all of the groups
# defined there (see: sso-admin-account-assignment.tf)

data "aws_identitystore_group" "groups" {
  for_each = toset([
    for assignment in local.teams_to_account_assignments_with_keys :
    assignment.github_team
  ])

  identity_store_id = local.sso_identity_store_id

  filter {
    attribute_path  = "DisplayName"
    attribute_value = each.value
  }
}
