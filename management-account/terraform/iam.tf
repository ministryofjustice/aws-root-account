#################
# Account Alias #
#################
resource "aws_iam_account_alias" "default" {
  account_alias = "mojmaster"
}

###################
# Password Policy #
###################
resource "aws_iam_account_password_policy" "default" {
  allow_users_to_change_password = true
  hard_expiry                    = false
  max_password_age               = 90
  minimum_password_length        = 14
  password_reuse_prevention      = 24
  require_lowercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  require_uppercase_characters   = true
}

####################################
# OIDC Provider for GitHub actions #
####################################
module "github_oidc" {
  source                = "../../modules/github-oidc-provider"
  repository_with_owner = "ministryofjustice/aws-root-account"
  repository_branch     = "main"
}
