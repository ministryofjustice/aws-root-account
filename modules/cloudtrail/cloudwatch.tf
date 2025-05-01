########################
# CloudWatch log group #
########################
resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "cloudtrail"
  retention_in_days = 0
  kms_key_id        = aws_kms_key.cloudtrail.arn
}

