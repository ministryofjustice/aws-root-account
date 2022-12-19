data "aws_identitystore_group" "default" {
  for_each = toset(distinct(local.sso_admin_account_assignments[*].github_team))

  identity_store_id = local.sso_admin_identity_store_id

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = each.value
    }
  }
}
