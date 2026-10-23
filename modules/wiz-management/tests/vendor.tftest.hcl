mock_provider "aws" {
  mock_data "aws_caller_identity" {
    defaults = { account_id = "123456789012" }
  }
  mock_data "aws_partition" {
    defaults = { partition = "aws", dns_suffix = "amazonaws.com" }
  }
}

override_data {
  target = data.aws_iam_policy.security_audit
  values = { arn = "arn:aws:iam::aws:policy/SecurityAudit" }
}

override_data {
  target = data.aws_iam_policy.view_only_access
  values = { arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess" }
}

variables {
  external-id = "00000000-0000-0000-0000-000000000000"
  remote-arn  = "arn:aws:iam::999999999999:role/Wiz"
}

run "vendor_default_resources" {
  command = plan
  module {
    source = "./vendor"
  }

  assert {
    condition = (
      length(aws_iam_policy.wiz_cloud_cost_policy) == 1 &&
      length(aws_iam_policy.wiz_defend_policy) == 1 &&
      length(aws_iam_policy.wiz_terraform_scanning_policy) == 1 &&
      length(aws_iam_policy.wiz_policy_data) == 0 &&
      length(aws_iam_policy.wiz_lightsail_policy) == 0 &&
      length(aws_iam_role_policy.wiz_policy_eks) == 0
    )
    error_message = "The vendor default plan must create only its default-enabled policies."
  }

  assert {
    condition = (
      jsondecode(aws_iam_role.user-role-tf.assume_role_policy).Statement[0].Principal.AWS == var.remote-arn &&
      jsondecode(aws_iam_role.user-role-tf.assume_role_policy).Statement[0].Condition.StringEquals["sts:ExternalId"] == var.external-id &&
      aws_iam_role_policy_attachment.security_audit_role_policy_attach.policy_arn == "arn:aws:iam::aws:policy/SecurityAudit" &&
      aws_iam_role_policy_attachment.view_only_access_role_policy_attach.policy_arn == "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
    )
    error_message = "Vendor trust and AWS-managed attachments must match the connector settings."
  }
}

run "vendor_all_features_policy_limits" {
  command = plan
  module {
    source = "./vendor"
  }
  variables {
    cloud-cost-scanning       = true
    data-scanning             = true
    eks-scanning              = true
    lightsail-scanning        = true
    wiz-defend-rds-policy     = true
    wiz-defend-awslogs-policy = true
    s3-inventory-scanning     = true
    wiz-defend-s3-kms-policy  = true
    terraform-bucket-scanning = true
  }

  assert {
    condition = alltrue([
      for document in [
        aws_iam_policy.wiz_cloud_cost_policy[0].policy,
        aws_iam_policy.wiz_policy_data[0].policy,
        aws_iam_policy.wiz_defend_policy[0].policy,
        aws_iam_policy.wiz_full_policy2.policy,
        aws_iam_policy.wiz_full_policy3.policy,
        aws_iam_policy.wiz_full_policy4.policy,
        aws_iam_policy.wiz_lightsail_policy[0].policy,
        aws_iam_policy.wiz_terraform_scanning_policy[0].policy,
      ] : length(jsonencode(jsondecode(document))) <= 6144
    ])
    error_message = "Every customer-managed policy must fit IAM's 6,144-character limit."
  }

  assert {
    condition = (
      length(jsonencode(jsondecode(aws_iam_role_policy.wiz_full_policy.policy))) +
      length(jsonencode(jsondecode(aws_iam_role_policy.wiz_policy_eks[0].policy))) <= 10240
    )
    error_message = "The role's aggregate inline policies must fit IAM's 10,240-character limit."
  }
}