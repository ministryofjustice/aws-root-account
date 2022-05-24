resource "aws_config_delivery_channel" "default" {
  name = "AWSConfig"

  s3_bucket_name = var.s3_bucket_name

  snapshot_delivery_properties {
    delivery_frequency = "One_Hour"
  }

  depends_on = [aws_config_configuration_recorder.default]
}

resource "aws_config_configuration_recorder" "default" {
  name     = "AWSConfig"
  role_arn = var.create_iam_role ? aws_iam_role.config["enabled"].arn : var.iam_role_arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = (data.aws_region.current.name == "us-east-1") ? true : false
  }
}

resource "aws_config_configuration_recorder_status" "default" {
  name       = aws_config_configuration_recorder.default.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.default]
}
