module "cloudtrail" {
  source = "github.com/ministryofjustice/modernisation-platform-terraform-baselines//modules/cloudtrail"
  providers = {
    aws.replication-region = aws.aws-root-account-eu-west-1
  }
  replication_role_arn = module.iam_s3_replication_role.role.arn
  tags = merge(local.root_account, {
    source-code = "${local.github_repository}/cloudtrail.tf"
  })
}
