locals {
  all_iam_users_and_groups = {
    "AliceCudmore" = [
      aws_iam_group.billing_full_access.name
    ]
    "AnthonyBishop" = [
      aws_iam_group.aws_organisations_service_admins.name,
      aws_iam_group.billing_full_access.name
    ]
    "CeriBuck" = [
      aws_iam_group.billing_full_access.name
    ]
    "Christine.Elliott" = [
      aws_iam_group.billing_full_access.name
    ]
    "claim-crown-court-defence" = []
    "JakeMulley" = [
      aws_iam_group.admins.name,
      aws_iam_group.aws_organisations_service_admins.name,
      aws_iam_group.billing_full_access.name
    ]
    "JasonBirchall" = [
      aws_iam_group.admins.name,
      aws_iam_group.aws_organisations_service_admins.name
    ]
    "LeahCios" = [
      aws_iam_group.billing_full_access.name
    ]
    "MaxLakanu" = [
      aws_iam_group.billing_full_access.name
    ]
    "ModernisationPlatformOrganisationManagement" = []
    "PaulWyborn" = [
      aws_iam_group.admins.name,
      aws_iam_group.aws_organisations_service_admins.name,
      aws_iam_group.billing_full_access.name
    ]
    "Poornima.Krishnasamy" = [
      aws_iam_group.admins.name,
      aws_iam_group.aws_organisations_service_admins.name
    ]
    "PSPI" = [
      aws_iam_group.billing_full_access.name
    ]
    "RohanSalunkhe" = [
      aws_iam_group.billing_full_access.name
    ]
    "SabluMiah" = [
      aws_iam_group.admins.name,
      aws_iam_group.aws_organisations_service_admins.name
    ]
    "SarahRees" = [
      aws_iam_group.billing_full_access.name
    ]
    "SeanBusby" = [
      aws_iam_group.admins.name,
      aws_iam_group.aws_organisations_service_admins.name,
      aws_iam_group.billing_full_access.name
    ]
    "SidElangovan" = [
      aws_iam_group.admins.name
    ]
    "SteveMarshall" = [
      aws_iam_group.admins.name,
      aws_iam_group.aws_organisations_service_admins.name,
      aws_iam_group.billing_full_access.name
    ]
  }
}

resource "aws_iam_user" "user" {
  for_each = local.all_iam_users_and_groups
  name     = each.key

  # This below is only so Terraform represents what is in the AWS account

  ## In the future...
  ## This should be true for all accounts so we can forcibly delete them even if the have AWS access keys set
  force_destroy = each.key == "ModernisationPlatformOrganisationManagement" ? true : false

  ## and this needs to be updated to tag all accounts with specifics
  tags = each.key == "claim-crown-court-defence" ? {
    Agency = "crimebillingonline"
    Owner  = "claim-crown-court-defence"
  } : {}
}

resource "aws_iam_user_group_membership" "group_memberships" {
  for_each = local.all_iam_users_and_groups
  user = aws_iam_user.user[each.key].name
  groups = each.value
}
