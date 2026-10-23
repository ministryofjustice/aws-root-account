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
  values = {
    account_id = "123456789012"
  }
}

override_data {
  target = data.aws_partition.wiz_management
  values = {
    partition  = "aws"
    dns_suffix = "amazonaws.com"
  }
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
      !var.wiz_features.s3_inventory_scanning
    )
    error_message = "Feature defaults must match the supplied vendor template."
  }

  assert {
    condition = (
      length(aws_iam_role_policy_attachment.wiz_management_aws_managed) == 2 &&
      length(aws_iam_policy.wiz_management_cloud_cost) == 1 &&
      length(aws_iam_policy.wiz_management_defend) == 1 &&
      length(aws_iam_policy.wiz_management_terraform) == 1 &&
      length(aws_iam_policy.wiz_management_data_scanning) == 0 &&
      length(aws_iam_policy.wiz_management_lightsail) == 0 &&
      length(aws_iam_role_policy.wiz_management_eks) == 0
    )
    error_message = "The default plan must create only the vendor-default policies."
  }

  assert {
    condition = (
      jsondecode(data.aws_iam_policy_document.wiz_management_trust.json).Statement[0].Principal.AWS == var.wiz_trust_role_arn &&
      jsondecode(data.aws_iam_policy_document.wiz_management_trust.json).Statement[0].Condition.StringEquals["sts:ExternalId"] == var.wiz_external_id
    )
    error_message = "Trust must be restricted to the configured Wiz role and connector external ID."
  }
}

run "all_features_policy_limits" {
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

  assert {
    condition = alltrue([
      for document in [
        data.aws_iam_policy_document.wiz_management_cloud_cost[0].json,
        data.aws_iam_policy_document.wiz_management_data_scanning[0].json,
        data.aws_iam_policy_document.wiz_management_defend[0].json,
        data.aws_iam_policy_document.wiz_management_full_2.json,
        data.aws_iam_policy_document.wiz_management_full_3.json,
        data.aws_iam_policy_document.wiz_management_full_4.json,
        data.aws_iam_policy_document.wiz_management_lightsail[0].json,
        data.aws_iam_policy_document.wiz_management_terraform[0].json,
      ] : length(jsonencode(jsondecode(document))) <= 6144
    ])
    error_message = "Every customer-managed policy must fit IAM's 6,144-character limit."
  }

  assert {
    condition = (
      length(jsonencode(jsondecode(data.aws_iam_policy_document.wiz_management_full.json))) +
      length(jsonencode(jsondecode(data.aws_iam_policy_document.wiz_management_eks[0].json))) <= 10240
    )
    error_message = "The role's aggregate inline policies must fit IAM's 10,240-character limit."
  }
}

run "reject_wrong_account" {
  command = plan
  variables {
    wiz_management_account_id = "111111111111"
  }
  expect_failures = [aws_iam_role.wiz_management]
}

run "reject_eks_with_role_path" {
  command = plan
  variables {
    wiz_role_path = "/trial/"
    wiz_features  = { eks_scanning = true }
  }
  expect_failures = [aws_iam_role.wiz_management]
}