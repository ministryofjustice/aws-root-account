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

# Configure an SNS topic in organisation-security for aggregated Config alerts for eu-west-1
# Note this needs to be configured for each region, as AWS Config doesn't support
# cross-region delivery to an SNS topic.
module "config-aggregation-sns-eu-west-1" {
  source = "./modules/config-aggregation-sns"
  providers = {
    aws = aws.organisation-security-eu-west-1
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

# Multi-region, Multi-account aggregation (MRMAA)
## Create an IAM role with appropriate permissions for AWS Config in organisation-security (delegated administrator)
module "config-organisation-security-iam-role" {
  source = "./modules/config-iam-role"
  providers = {
    aws = aws.organisation-security-eu-west-2
  }

  s3_bucket_arn = module.config-aggregation-bucket.s3_bucket_arn
  sns_topic_arns = [
    module.config-aggregation-sns-eu-west-2.sns_topic_arn,
    module.config-aggregation-sns-eu-west-1.sns_topic_arn
  ]
}

## Enable AWS Config in eu-west-2 within the organisation-security account
## You need to enable Config in the delegated administrator account before you can create an aggregator.
module "config-organisation-security-eu-west-2" {
  source = "./modules/config"
  providers = {
    aws = aws.organisation-security-eu-west-2
  }

  s3_bucket_name = module.config-aggregation-bucket.s3_bucket_name
  sns_topic_arn  = module.config-aggregation-sns-eu-west-2.sns_topic_arn
  iam_role_arn   = module.config-organisation-security-iam-role.role_arn
  home_region    = "eu-west-2"
}

# Enable Multi-region, multi-account aggregation via AWS Organizations
module "config-aggregation" {
  source = "./modules/config-aggregation"
  providers = {
    aws.root-account            = aws.aws-root-account-eu-west-2
    aws.delegated-administrator = aws.organisation-security-eu-west-2
  }
}
