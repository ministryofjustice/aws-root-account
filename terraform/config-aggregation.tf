# Accounts that are enrolled into aggregating Config findings into the organisation-security
# S3 bucket and SNS topics.
# Note that this different from multi-region, multi-account aggregation (MRMAA) in AWS Config,
# in that you can do MRMAA without delivering configuration changes to a central S3 bucket.
locals {
  enrolled_into_config = [
    { id = local.caller_identity.account_id, name = "MoJ root account" }
  ]
}

# Configure an S3 bucket in organisation-security for aggregated Config logs
# Note this only needs to be configured once, as AWS Config supports cross-account,
# cross-region delivery to an S3 bucket.
module "config-aggregation-bucket" {
  source = "./modules/config-aggregation-bucket"
  providers = {
    aws = aws.organisation-security-eu-west-2
  }

  # Bucket prefix to use
  bucket_prefix = "moj-config"

  # Specify account IDs that have access to the S3 bucket
  enrolled_account_ids = [
    for account in local.enrolled_into_config :
    account.id
  ]

  # Tags to apply, where applicable
  tags = merge(
    local.tags-organisation-management, {
      component = "Security"
    }
  )
}

# Configure an SNS topic in organisation-security for aggregated Config alerts for eu-west-2
# Note this needs to be configured for each region, as AWS Config doesn't support
# cross-region delivery to an SNS topic.
module "config-aggregation-sns-eu-west-2" {
  source = "./modules/config-aggregation-sns"
  providers = {
    aws = aws.organisation-security-eu-west-2
  }

  # Specify account IDs that can send notifications to the topic
  enrolled_account_ids = [
    for account in local.enrolled_into_config :
    account.id
  ]

  # Tags to apply, where applicable
  tags = merge(
    local.tags-organisation-management, {
      component = "Security"
    }
  )
}
