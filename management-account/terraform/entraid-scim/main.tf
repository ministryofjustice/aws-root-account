data "azuread_groups" "azure_aws_sso" {
  display_name_prefix = "azure-aws-sso-"
}

data "azuread_group" "entraid_group_data" {
  for_each     = toset(data.azuread_groups.azure_aws_sso.display_names)
  display_name = each.value
}

data "azuread_user" "entraid_group_members" {
  for_each = toset(flatten(local.azuread_group_members))
  object_id       = each.value
}

resource "aws_identitystore_group" "groups" {
  for_each          = toset(data.azuread_groups.azure_aws_sso.display_names)
  identity_store_id = tolist(data.aws_ssoadmin_instances.identity_store.identity_store_ids)[0]
  display_name      = each.key
}

resource "aws_identitystore_user" "entraid_synchronised_users" {
  for_each          = data.azuread_user.entraid_group_members
  identity_store_id = tolist(data.aws_ssoadmin_instances.identity_store.identity_store_ids)[0]

  display_name = each.value.display_name
  user_name    = each.value.user_principal_name

  name {
    given_name  = each.value.given_name
    family_name = each.value.surname
  }

  emails {
    value   = each.value.mail
    primary = true
    type    = "EntraId"
  }
}

resource "aws_identitystore_group_membership" "add_users" {
  # Create a unique key for each group-member combination
  for_each = {
    for entry in local.group_memberships :
    "${entry.group_name}-${entry.member_name}" => entry
  }

  identity_store_id = tolist(data.aws_ssoadmin_instances.identity_store.identity_store_ids)[0]
  group_id          = aws_identitystore_group.groups[each.value.group_name].id
  member_id         = aws_identitystore_user.entraid_synchronised_users[each.value.member_name].user_id
}