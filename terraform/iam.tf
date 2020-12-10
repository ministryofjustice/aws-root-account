resource "aws_iam_account_alias" "default" {
  account_alias = "mojmaster"
}

# Uses the Modernisation Platform IAM password policy to follow the CIS benchmark
module "iam_password_policy" {
  source = "github.com/ministryofjustice/modernisation-platform-terraform-baselines//modules/iam"
}
