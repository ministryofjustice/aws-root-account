# This uses the local.teams_to_account_assignments list, and looks up the teams
# defined there (see: sso-admin-account-assignment.tf)

data "aws_identitystore_group" "groups" {
  for_each = toset(distinct(local.teams_to_account_assignments[*].github_team))

  identity_store_id = local.sso_identity_store_id

  filter {
    attribute_path  = "DisplayName"
    attribute_value = each.value
  }
}
