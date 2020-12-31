##############################
# SNS topics for AWS Config  #
##############################
# See: https://docs.aws.amazon.com/config/latest/developerguide/gs-cli-prereq.html
# Note that SNS topics in AWS Config only support same region and cross account access,
# so you need to configure a new one for each region Config is enabled in.

# SNS topic policy for a SNS topic in another account
# See: https://docs.aws.amazon.com/config/latest/developerguide/sns-topic-policy.html
data "aws_iam_policy_document" "config-sns-topic-policy-eu-west-2" {
  version = "2012-10-17"

  statement {
    effect    = "Allow"
    actions   = ["SNS:Publish"]
    resources = [aws_sns_topic.config-sns-topic-eu-west-2.arn]

    principals {
      type = "AWS"
      identifiers = [
        local.caller_identity.id
      ]
    }
  }
}

resource "aws_sns_topic" "config-sns-topic-eu-west-2" {
  # Set the provider to organisation-security, as that's where we manage Config aggregation
  provider = aws.organisation-security-eu-west-2

  name              = "config-sns-topic"
  kms_master_key_id = aws_kms_key.config.id

  tags = merge(
    local.tags-organisation-management, {
      component = "Security"
    }
  )
}

resource "aws_sns_topic_policy" "config-sns-topic-policy-eu-west-2" {
  # Set the provider to organisation-security, as that's where we manage Config aggregation
  provider = aws.organisation-security-eu-west-2

  arn    = aws_sns_topic.config-sns-topic-eu-west-2.arn
  policy = data.aws_iam_policy_document.config-sns-topic-policy-eu-west-2.json
}
