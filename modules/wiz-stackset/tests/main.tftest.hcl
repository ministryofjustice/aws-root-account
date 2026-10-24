mock_provider "aws" {}

# The upstream comparison has its own tests in upstream-check/tests.
override_module {
  target = module.wiz_upstream_check
}

variables {
  wiz_external_id   = "00000000-0000-0000-0000-000000000000"
  wiz_role_arn      = "arn:aws:iam::999999999999:role/Wiz"
  wiz_target_ou_ids = ["ou-abcd-12345678"]
}

run "vendor_defaults" {
  command = plan

  assert {
    condition = alltrue([
      for name in ["CloudCostScanning", "RDSLogsScanning", "S3AWSLogsScanning", "S3KMSDecrypt", "TerraformBucketScanning"] :
      aws_cloudformation_stack_set.wiz.parameters[name] == "Enabled"
    ])
    error_message = "Vendor-enabled features must remain enabled."
  }

  assert {
    condition = alltrue([
      for name in ["DataScanning", "EKSScanning", "LightsailScanning", "S3InventoryScanning"] :
      aws_cloudformation_stack_set.wiz.parameters[name] == "Disabled"
    ])
    error_message = "Vendor-disabled features must remain disabled."
  }

  assert {
    condition = (
      aws_cloudformation_stack_set.wiz.call_as == "DELEGATED_ADMIN" &&
      aws_cloudformation_stack_set.wiz.permission_model == "SERVICE_MANAGED" &&
      aws_cloudformation_stack_set.wiz.auto_deployment[0].enabled &&
      !aws_cloudformation_stack_set.wiz.auto_deployment[0].retain_stacks_on_account_removal &&
      !aws_cloudformation_stack_set_instance.wiz.retain_stack &&
      aws_cloudformation_stack_set_instance.wiz.stack_set_instance_region == "eu-west-2" &&
      aws_cloudformation_stack_set_instance.wiz.deployment_targets[0].organizational_unit_ids == toset(["ou-abcd-12345678"])
    )
    error_message = "Deployment must use the delegated administrator, the specified OU, one region, and explicit deletion defaults."
  }

  assert {
    condition = (
      aws_cloudformation_stack_set.wiz.operation_preferences[0].failure_tolerance_count == 0 &&
      aws_cloudformation_stack_set.wiz.operation_preferences[0].max_concurrent_count == 1 &&
      aws_cloudformation_stack_set.wiz.operation_preferences[0].failure_tolerance_percentage == null &&
      aws_cloudformation_stack_set.wiz.operation_preferences[0].max_concurrent_percentage == null &&
      aws_cloudformation_stack_set_instance.wiz.operation_preferences[0].failure_tolerance_count == 0 &&
      aws_cloudformation_stack_set_instance.wiz.operation_preferences[0].max_concurrent_count == 1 &&
      aws_cloudformation_stack_set_instance.wiz.operation_preferences[0].failure_tolerance_percentage == null &&
      aws_cloudformation_stack_set_instance.wiz.operation_preferences[0].max_concurrent_percentage == null
    )
    error_message = "Both rollout operations must tolerate zero failures and process one account at a time, using counts rather than percentages."
  }

  assert {
    condition     = length(aws_cloudformation_stack_set.wiz.template_body) <= 51200
    error_message = "The rendered member template must fit the CloudFormation inline limit."
  }
}

run "reject_placeholder_ou" {
  command = plan
  variables {
    wiz_target_ou_ids = ["placeholder OU"]
  }
  expect_failures = [var.wiz_target_ou_ids]
}

run "reject_invalid_rollout_counts" {
  command = plan
  variables {
    wiz_failure_tolerance_count = -1
    wiz_max_concurrent_count    = 0
  }
  expect_failures = [var.wiz_failure_tolerance_count, var.wiz_max_concurrent_count]
}

run "reject_fractional_rollout_counts" {
  command = plan
  variables {
    wiz_failure_tolerance_count = 0.5
    wiz_max_concurrent_count    = 1.5
  }
  expect_failures = [var.wiz_failure_tolerance_count, var.wiz_max_concurrent_count]
}

run "reject_invalid_trust_account" {
  command = plan
  variables {
    wiz_role_arn = "arn:aws:iam::123:role/Wiz"
  }
  expect_failures = [var.wiz_role_arn]
}

run "reject_reserved_override" {
  command = plan
  variables {
    wiz_template_parameters = { ExternalId = "different-external-id" }
  }
  expect_failures = [aws_cloudformation_stack_set.wiz]
}

run "reject_unknown_override" {
  command = plan
  variables {
    wiz_template_parameters = { UnknownFeature = "Enabled" }
  }
  expect_failures = [aws_cloudformation_stack_set.wiz]
}

run "reject_eks_with_role_path" {
  command = plan
  variables {
    wiz_template_parameters = { EKSScanning = "Enabled", RolePath = "/trial/" }
  }
  expect_failures = [aws_cloudformation_stack_set.wiz]
}
