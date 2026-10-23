provider "aws" {
  region                      = "eu-west-2"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
}

override_data {
  target = data.aws_caller_identity.wiz_management
  values = { account_id = "123456789012" }
}

override_data {
  target = data.aws_partition.wiz_management
  values = { partition = "aws", dns_suffix = "amazonaws.com" }
}

override_data {
  target = module.vendor.data.aws_caller_identity.current
  values = { account_id = "123456789012" }
}

override_data {
  target = module.vendor.data.aws_partition.current
  values = { partition = "aws", dns_suffix = "amazonaws.com" }
}

override_data {
  target = module.vendor.data.aws_iam_policy.security_audit
  values = { arn = "arn:aws:iam::aws:policy/SecurityAudit" }
}

override_data {
  target = module.vendor.data.aws_iam_policy.view_only_access
  values = { arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess" }
}

variables {
  wiz_management_account_id = "123456789012"
  wiz_external_id           = "00000000-0000-0000-0000-000000000000"
  wiz_trust_role_arn        = "arn:aws:iam::999999999999:role/Wiz"
}

run "vendor_defaults" {
  command = plan

  assert {
    condition = (
      var.wiz_features.cloud_cost_scanning &&
      var.wiz_features.rds_logs_scanning &&
      var.wiz_features.s3_aws_logs_scanning &&
      var.wiz_features.s3_kms_decrypt &&
      var.wiz_features.terraform_bucket_scanning &&
      !var.wiz_features.data_scanning &&
      !var.wiz_features.eks_scanning &&
      !var.wiz_features.lightsail_scanning &&
      !var.wiz_features.s3_inventory_scanning &&
      module.vendor.wiz_last_updated.wiz_version_last_updated == "2026-10-21"
    )
    error_message = "The wrapper must retain the reviewed vendor version and feature defaults."
  }
}

run "all_features_enabled" {
  command = plan
  variables {
    wiz_features = {
      cloud_cost_scanning       = true
      data_scanning             = true
      eks_scanning              = true
      lightsail_scanning        = true
      rds_logs_scanning         = true
      s3_aws_logs_scanning      = true
      s3_inventory_scanning     = true
      s3_kms_decrypt            = true
      terraform_bucket_scanning = true
    }
  }
}

run "reject_wrong_account" {
  command = plan
  variables {
    wiz_management_account_id = "111111111111"
  }
  expect_failures = [data.aws_caller_identity.wiz_management]
}

run "reject_eks_with_role_path" {
  command = plan
  variables {
    wiz_role_path = "/trial/"
    wiz_features  = { eks_scanning = true }
  }
  expect_failures = [data.aws_caller_identity.wiz_management]
}