# The Modernisation Platform manage their own sub-OUs and sub-accounts.
# The account listed here is their landing account.
# See: https://github.com/ministryofjustice/modernisation-platform

locals {
  tags-modernisation-platform = {
    business-unit = "Platforms"
  }
}

resource "aws_organizations_account" "modernisation-platform" {
  name      = "Modernisation Platform"
  email     = local.aws_account_email_addresses["Modernisation Platform"][0]
  parent_id = aws_organizations_organizational_unit.platforms-and-architecture-modernisation-platform.id

  lifecycle {
    # If any of these attributes are changed, it attempts to destroy and recreate the account,
    # so we should ignore the changes to prevent this from happening.
    ignore_changes = [
      name,
      email,
      iam_user_access_to_billing,
      role_name
    ]
  }

  tags = local.tags-modernisation-platform
}

# Below is a data source to get all Modernisation Platform-managed AWS accounts in a key => value
# format, where key is the account name and value is their ID; which is stored in AWS Secrets Manager
# on their side. We then store it in a local with the required map format:
# { id => "account_id", name => "account name" } for the GuardDuty implementation
# in this repository
data "aws_secretsmanager_secret" "modernisation-platform-environment-management" {
  provider = aws.modernisation-platform
  name     = "environment_management"
}

data "aws_secretsmanager_secret_version" "modernisation-platform-account-ids" {
  provider  = aws.modernisation-platform
  secret_id = data.aws_secretsmanager_secret.modernisation-platform-environment-management.id
}

locals {
  modernisation-platform-managed-account-ids = [
    for key, value in jsondecode(data.aws_secretsmanager_secret_version.modernisation-platform-account-ids.secret_string).account_ids : {
      id   = value
      name = key
    }
  ]

  modernisation_platform_environment_management = jsondecode(data.aws_secretsmanager_secret_version.modernisation-platform-account-ids.secret_string)

}
