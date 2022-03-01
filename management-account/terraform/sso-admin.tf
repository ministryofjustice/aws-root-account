data "aws_ssoadmin_instances" "default" {}

locals {
  sso_admin_instance_arn      = coalesce(data.aws_ssoadmin_instances.default.arns...)
  sso_admin_identity_store_id = coalesce(data.aws_ssoadmin_instances.default.identity_store_ids...)
}
