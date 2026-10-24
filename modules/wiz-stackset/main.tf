# Wiz organisation deployment: vendor CloudFormation, managed by Terraform.
# Prepared 2026-10-23. Vendor template version: 2026-10-21.
# Source: https://wizio-public.s3.amazonaws.com/deployment-v2/aws/wiz-aws-standard.json
# wiz-aws-standard.json is that source, unmodified; plans fail if its SHA-256
# differs from wiz_template_sha256. Plans warn when Wiz publishes a newer version,
# but the deployed template only changes when the committed file is updated.
#
# WHAT THIS CREATES
# - Terraform owns one service-managed StackSet and its OU deployment target.
# - CloudFormation owns Wiz IAM resources inside each targeted member account.
# - New accounts entering the targeted OUs enrol without another Terraform run.
# - No outer org CloudFormation stack and no nested StackSet are created.
# - The member template contains only IAM resources: one role, eight managed
#   policy resources and two inline policy resources (some are conditional).
# - This file does not register delegated administration or enable trusted access.
#
# USE
# Use as a child module or alongside your existing organisation-security Terraform.
# Supply an AWS provider authenticated to the StackSets delegated administrator;
# configure that provider in eu-west-2 (or your agreed StackSets control region).
# Required inputs: wiz_external_id, wiz_role_arn, wiz_target_ou_ids.
# wiz_role_arn is Wiz's tenant/DC trust ROLE ARN, not your deployment role.
# Optional feature overrides: wiz_template_parameters = { DataScanning = "Enabled" }.
# Every omitted option retains the vendor default; review those defaults below.
# Run terraform init, terraform plan and review before any apply.
#
# BEHAVIOUR / LIMITS
# - AWS excludes the management account from service-managed StackSet deployment;
#   its Wiz role and organisation discovery connector still need separate setup.
# - IAM is global: use one deployment region to avoid role/policy name collisions.
# - Existing pilot roles/stacks must be reconciled before targeting their accounts.
# - StackSet auto-removal and explicit target destruction both DELETE member stacks
#   by default. Retention inputs below make both choices explicit.
# - Trial rollout allows zero failures and processes one account at a time.
#   These operation settings deliberately differ from Wiz's 50/50 defaults.
# - An optional permission boundary must already exist in EVERY target account.
# - Feature defaults include Terraform-bucket, AWS-log, KMS-decrypt, RDS-log and
#   cloud-cost access. This is not a generic read-only or configuration-only role.
# - No AWS plan, apply, IAM-policy simulation or Wiz connector test has been run.
# - With no outer root stack, WizRootStackId/WizRootStackFilename stay empty by
#   default; ask Wiz to confirm its connector/updater supports direct StackSets.
#
# Local checks: terraform validate and mocked plan tests in tests/main.tftest.hcl.
# Review an authenticated Terraform plan before deploying.

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.69.1, < 7.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.4, < 4.0"
    }
  }
}

variable "wiz_external_id" {
  type        = string
  sensitive   = true
  description = "ExternalId from your Wiz AWS connector. Not an AWS credential."
  validation {
    condition     = can(regex("^\\S{8}-\\S{4}-\\S{4}-\\S{4}-\\S{12}$", var.wiz_external_id))
    error_message = "Use the ExternalId supplied by Wiz (UUID-shaped, 36 characters)."
  }
}

variable "wiz_role_arn" {
  type        = string
  description = "RoleARN: Wiz's tenant/data-centre trust policy role ARN."
  validation {
    condition     = can(regex("^arn:aws(-us-gov|-cn)?:iam::[0-9]{12}:role/.+$", var.wiz_role_arn))
    error_message = "Supply the Wiz trust role ARN from your tenant settings."
  }
}

variable "wiz_target_ou_ids" {
  type        = set(string)
  description = "Organisation root and/or OU IDs to target; includes descendant OUs."
  validation {
    condition = length(var.wiz_target_ou_ids) > 0 && alltrue([
      for id in var.wiz_target_ou_ids : can(regex("^(r-[a-z0-9]{4,32}|ou-[a-z0-9]{4,32}-[a-z0-9]{8,32})$", id))
    ])
    error_message = "Provide at least one valid AWS organisation root or OU ID."
  }
}

variable "wiz_stackset_name" {
  type        = string
  default     = "WizMemberAccountAccess"
  description = "Name of the central StackSet."
}

variable "wiz_deployment_region" {
  type        = string
  default     = "eu-west-2"
  description = "Single target stack region; IAM roles and policies are global."
}

variable "wiz_template_parameters" {
  type        = map(string)
  default     = {}
  description = "Optional member-template parameter overrides; omitted options retain vendor defaults. ExternalId, RoleARN and version are fixed separately."
}

variable "wiz_tags" {
  type        = map(string)
  default     = {}
  description = "Tags applied to the central StackSet."
}

variable "wiz_retain_on_account_removal" {
  type        = bool
  default     = false
  description = "Retain member stacks when an account leaves the targeted OU scope."
}

variable "wiz_retain_on_target_destroy" {
  type        = bool
  default     = false
  description = "Retain member stacks when Terraform destroys the deployment target."
}

variable "wiz_failure_tolerance_count" {
  type        = number
  default     = 0
  description = "Number of account failures tolerated before stopping the rollout; zero for the trial."
  validation {
    condition     = var.wiz_failure_tolerance_count >= 0 && floor(var.wiz_failure_tolerance_count) == var.wiz_failure_tolerance_count
    error_message = "Failure tolerance must be a non-negative integer."
  }
}

variable "wiz_max_concurrent_count" {
  type        = number
  default     = 1
  description = "Maximum number of accounts processed concurrently; one for the trial."
  validation {
    condition     = var.wiz_max_concurrent_count >= 1 && floor(var.wiz_max_concurrent_count) == var.wiz_max_concurrent_count
    error_message = "Concurrency must be a positive integer."
  }
}

locals {
  wiz_default_parameters = {
    for name, spec in local.wiz_member_template.Parameters :
    name => spec.Default if contains(keys(spec), "Default")
  }

  wiz_parameters = merge(
    local.wiz_default_parameters,
    var.wiz_template_parameters,
    {
      ExternalId            = var.wiz_external_id
      RoleARN               = var.wiz_role_arn
      WizVersionLastUpdated = local.wiz_member_template.Parameters.WizVersionLastUpdated.Default
    }
  )

  wiz_allowed_override_keys = setsubtract(
    toset(keys(local.wiz_member_template.Parameters)),
    toset(["ExternalId", "RoleARN", "WizVersionLastUpdated"])
  )
}

resource "aws_cloudformation_stack_set" "wiz" {
  name             = var.wiz_stackset_name
  description      = "Wiz member-account access; reviewed vendor template ${local.wiz_pinned_version}"
  call_as          = "DELEGATED_ADMIN"
  permission_model = "SERVICE_MANAGED"
  capabilities     = ["CAPABILITY_NAMED_IAM"]

  template_body = jsonencode(local.wiz_member_template)
  parameters    = local.wiz_parameters
  tags          = var.wiz_tags

  auto_deployment {
    enabled                          = true
    retain_stacks_on_account_removal = var.wiz_retain_on_account_removal
  }

  managed_execution {
    active = true
  }

  operation_preferences {
    failure_tolerance_count = var.wiz_failure_tolerance_count
    max_concurrent_count    = var.wiz_max_concurrent_count
    region_concurrency_type = "PARALLEL"
  }

  lifecycle {
    precondition {
      condition     = filesha256(local.wiz_template_path) == local.wiz_template_sha256
      error_message = "wiz-aws-standard.json differs from the reviewed vendor source. Review the change and update wiz_template_sha256."
    }
    precondition {
      condition     = length(setsubtract(toset(keys(var.wiz_template_parameters)), local.wiz_allowed_override_keys)) == 0
      error_message = "Unknown or reserved Wiz template parameter override. Use wiz_external_id and wiz_role_arn for required values; retain the pinned version."
    }
    precondition {
      condition     = length(jsonencode(local.wiz_member_template)) <= 51200
      error_message = "Template exceeds template_body limit; publish the reviewed vendor JSON to your own S3 bucket and use template_url."
    }
    precondition {
      condition     = local.wiz_parameters.EKSScanning != "Enabled" || local.wiz_parameters.RolePath == "/"
      error_message = "The vendor EKS policy assumes the default role path /. Retain / when EKSScanning is enabled."
    }
  }
}

resource "aws_cloudformation_stack_set_instance" "wiz" {
  call_as                   = "DELEGATED_ADMIN"
  stack_set_name            = aws_cloudformation_stack_set.wiz.name
  stack_set_instance_region = var.wiz_deployment_region
  retain_stack              = var.wiz_retain_on_target_destroy

  deployment_targets {
    organizational_unit_ids = sort(tolist(var.wiz_target_ou_ids))
  }

  operation_preferences {
    failure_tolerance_count = var.wiz_failure_tolerance_count
    max_concurrent_count    = var.wiz_max_concurrent_count
    region_concurrency_type = "PARALLEL"
  }
}

output "wiz_stackset_id" {
  value       = aws_cloudformation_stack_set.wiz.stack_set_id
  description = "StackSet identifier; not evidence that every target account is healthy."
}

# Vendor member-account template, committed byte-for-byte from the source URL.
# Keep CloudFormation logical IDs stable across updates. To update: download the
# new file, review its diff, and update wiz_template_sha256.

locals {
  wiz_template_path   = "${path.module}/wiz-aws-standard.json"
  wiz_template_sha256 = "4081ebae61dafe47db0f312d0681f6f95b71343038c8637277b35d41756f1ae7"
  wiz_member_template = jsondecode(file(local.wiz_template_path))
  wiz_pinned_version  = local.wiz_member_template.Parameters.WizVersionLastUpdated.Default
}

# Warns, without failing the plan, when Wiz publishes a newer template. The data
# source sits outside the check block: a scoped data source is always deferred
# to apply, which would make every plan report changes.
data "http" "wiz_upstream" {
  url = "https://wizio-public.s3.amazonaws.com/deployment-v2/aws/wiz-aws-standard.json"
}

locals {
  wiz_upstream_version = try(jsondecode(data.http.wiz_upstream.response_body).Parameters.WizVersionLastUpdated.Default, "unreadable")
}

check "wiz_template_current" {
  assert {
    condition     = local.wiz_upstream_version == local.wiz_pinned_version
    error_message = "Wiz has published member template ${local.wiz_upstream_version}; this repository pins ${local.wiz_pinned_version}. Review the upstream changes and update modules/wiz-stackset/wiz-aws-standard.json."
  }
}
