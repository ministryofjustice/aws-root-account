resource "aws_fms_admin_account" "default" {
  provider   = aws.aws-root-account-us-east-1
  account_id = aws_organizations_account.organisation-security.id
}
