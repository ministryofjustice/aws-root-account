locals {
  iam_users = [
    "AliceCudmore",
    "AnthonyBishop",
    "CeriBuck",
    "Christine.Elliott",
    "claim-crown-court-defence",
    "JakeMulley",
    "JasonBirchall",
    "LeahCios",
    "MaxLakanu",
    "ModernisationPlatformOrganisationManagement",
    "PaulWyborn",
    "Poornima.Krishnasamy",
    "PSPI",
    "RohanSalunkhe",
    "SabluMiah",
    "SarahRees",
    "SeanBusby",
    "SidElangovan",
    "SteveMarshall"
  ]
}

resource "aws_iam_user" "user" {
  for_each = toset(local.iam_users)
  name     = each.value

  # This below is only so Terraform represents what is in the AWS account

  ## In the future...
  ## This should be true for all accounts so we can forcibly delete them even if the have AWS access keys set
  force_destroy = each.value == "ModernisationPlatformOrganisationManagement" ? true : false

  ## and this needs to be updated to tag all accounts with specifics
  tags = each.value == "claim-crown-court-defence" ? {
    Agency = "crimebillingonline"
    Owner  = "claim-crown-court-defence"
  } : {}
}
