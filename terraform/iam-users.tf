locals {
  all_iam_users_and_groups = {
    "AnthonyBishop" = [
      aws_iam_group.aws_organisations_service_admins.name,
      aws_iam_group.billing_full_access.name,
      aws_iam_group.iam_user_change_password.name
    ]
    "DavidElliott" = [
      aws_iam_group.modernisation_platform_restricted_organisations_administrator.name
    ]
    "JakeMulley" = [
      aws_iam_group.admins.name,
      aws_iam_group.aws_organisations_service_admins.name,
      aws_iam_group.billing_full_access.name,
      aws_iam_group.iam_user_change_password.name
    ]
    "JasonBirchall" = [
      aws_iam_group.admins.name,
      aws_iam_group.aws_organisations_service_admins.name,
      aws_iam_group.iam_user_change_password.name
    ]
    "JulieRobertson" = [
      aws_iam_group.billing_full_access.name,
      aws_iam_group.iam_user_change_password.name
    ]
    "ModernisationPlatformOrganisationManagement" = [
      aws_iam_group.modernisation_platform_restricted_organisations_administrator.name
    ]
    "PaulWyborn" = [
      aws_iam_group.admins.name,
      aws_iam_group.aws_organisations_service_admins.name,
      aws_iam_group.billing_full_access.name,
      aws_iam_group.iam_user_change_password.name
    ]
    "Poornima.Krishnasamy" = [
      aws_iam_group.admins.name,
      aws_iam_group.aws_organisations_service_admins.name
    ]
    "SabluMiah" = [
      aws_iam_group.admins.name,
      aws_iam_group.aws_organisations_service_admins.name,
      aws_iam_group.iam_user_change_password.name
    ]
    "SteveMarshall" = [
      aws_iam_group.admins.name,
      aws_iam_group.aws_organisations_service_admins.name,
      aws_iam_group.billing_full_access.name,
      aws_iam_group.iam_user_change_password.name
    ]
  }
}

# IAM User
resource "aws_iam_user" "user" {
  for_each = local.all_iam_users_and_groups
  name     = each.key

  # This below is only so Terraform represents what is in the AWS account

  ## In the future...
  ## This should be true for all accounts so we can forcibly delete them even if the have AWS access keys set
  force_destroy = each.key == "ModernisationPlatformOrganisationManagement" ? true : false

  ## and this needs to be updated to tag all accounts with specifics
  tags = {}
}

# IAM User Group Memberships
resource "aws_iam_user_group_membership" "group_memberships" {
  for_each = local.all_iam_users_and_groups
  user     = aws_iam_user.user[each.key].name
  groups   = each.value
}
