resource "aws_iam_account_alias" "default" {
  account_alias = "mojmaster"
}

# In the future, we can use the Modernisation Platform's module for password policies, which complies with the
# CIS AWS Foundations Benchmark v1.2.0 rules, see:
# https://github.com/ministryofjustice/modernisation-platform-terraform-baselines/tree/main/modules/iam#iam-password-policy
resource "aws_iam_account_password_policy" "default" {
  allow_users_to_change_password = true
  hard_expiry                    = false
  max_password_age               = 0
  minimum_password_length        = 8
  password_reuse_prevention      = 0
  require_lowercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  require_uppercase_characters   = true
}
