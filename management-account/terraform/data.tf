data "aws_caller_identity" "current" {}

data "aws_ssoadmin_instances" "moj" {}

data "aws_ssm_parameter" "cortex_account_id" {
  name = "cortex_account_id"
}
