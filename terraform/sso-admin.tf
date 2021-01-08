# Get AWS SSO instances. Note that this returns a list,
# although AWS SSO only supports singular SSO instances.
data "aws_ssoadmin_instances" "default" {}

locals {
  sso_instance_arn = coalesce(data.aws_ssoadmin_instances.default.arns...)
}
