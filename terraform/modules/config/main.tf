##########
# Config #
##########

data "aws_region" "current" {}

# Enable Config
resource "aws_config_delivery_channel" "default" {
  name           = "AWSConfig"
  s3_bucket_name = var.s3_bucket_name
  sns_topic_arn  = var.sns_topic_arn

  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }

  depends_on = [aws_config_configuration_recorder.default]
}

resource "aws_config_configuration_recorder" "default" {
  name     = "AWSConfig"
  role_arn = var.iam_role_arn

  recording_group {
    all_supported = true
    # Enable global resource types for the default (home) region
    # For other regions, you should set it to false to reduce cost and duplication
    include_global_resource_types = (var.home_region == data.aws_region.current.name) ? true : false
  }
}

resource "aws_config_configuration_recorder_status" "default" {
  name       = "AWSConfig"
  is_enabled = true
  depends_on = [aws_config_delivery_channel.default]
}
