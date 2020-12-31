##############################
# Config within eu-west-2    #
##############################

# Enable Config for the default provider region
resource "aws_config_delivery_channel" "default-region" {
  name           = "AWSConfig"
  s3_bucket_name = aws_s3_bucket.config-bucket.id
  sns_topic_arn  = aws_sns_topic.config-sns-topic-eu-west-2.arn

  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }

  depends_on = [aws_config_configuration_recorder.default-region]
}

resource "aws_config_configuration_recorder" "default-region" {
  name     = "AWSConfig"
  role_arn = aws_iam_role.config.arn

  recording_group {
    all_supported = true
    # Enable global resource types for the default (home) region
    # For other regions, you should set it to false to reduce cost and duplication
    include_global_resource_types = true
  }
}

resource "aws_config_configuration_recorder_status" "default-region" {
  name       = "AWSConfig"
  is_enabled = true
  depends_on = [aws_config_delivery_channel.default-region]
}
