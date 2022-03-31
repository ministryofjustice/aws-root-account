########################
# CloudTrail SNS topic #
########################
resource "aws_sns_topic" "cloudtrail" {
  name              = "cloudtrail"
  kms_master_key_id = aws_kms_key.cloudtrail.id
}

####################
# SNS topic policy #
####################
resource "aws_sns_topic_policy" "cloudtrail" {
  arn    = aws_sns_topic.cloudtrail.arn
  policy = data.aws_iam_policy_document.sns_topic.json
}

data "aws_iam_policy_document" "sns_topic" {
  version = "2012-10-17"

  statement {
    effect    = "Allow"
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.cloudtrail.arn]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}
