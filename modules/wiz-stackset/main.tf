# Wiz organisation deployment: HCL-authored CloudFormation, managed by Terraform.
# Prepared 2026-10-23. Vendor template version: 2026-10-21.
# Source: https://wizio-public.s3.amazonaws.com/deployment-v2/aws/wiz-aws-standard.json
# wiz-aws-standard.json is that source, unmodified; plans fail if its SHA-256
# differs from wiz_template_sha256, or if the wiz_member_template HCL below does
# not decode to the same JSON. Plans warn when Wiz's published file differs from
# the committed copy; the deployed template only changes when the HCL is updated.
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
# - CloudFormation intrinsic functions are intentionally retained as HCL objects:
#   they resolve account-specific values and conditional statements in each account.
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
  description      = "Wiz member-account access; reviewed HCL template ${local.wiz_pinned_version}"
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
      condition     = jsonencode(local.wiz_member_template) == jsonencode(local.wiz_vendor_template)
      error_message = "The HCL template differs from wiz-aws-standard.json. Regenerate the HCL from the committed vendor file."
    }
    precondition {
      condition     = length(setsubtract(toset(keys(var.wiz_template_parameters)), local.wiz_allowed_override_keys)) == 0
      error_message = "Unknown or reserved Wiz template parameter override. Use wiz_external_id and wiz_role_arn for required values; retain the pinned version."
    }
    precondition {
      condition     = length(jsonencode(local.wiz_member_template)) <= 51200
      error_message = "Template exceeds template_body limit; publish the reviewed generated JSON to your own S3 bucket and use template_url."
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

# Committed vendor source, byte-for-byte from the source URL. It is not deployed:
# it verifies the HCL template below and detects upstream changes. To update:
# download the new file, review its diff, update wiz_template_sha256, then
# regenerate the HCL so it matches.

locals {
  wiz_template_path   = "${path.module}/wiz-aws-standard.json"
  wiz_template_sha256 = "4081ebae61dafe47db0f312d0681f6f95b71343038c8637277b35d41756f1ae7"
  wiz_vendor_template = jsondecode(file(local.wiz_template_path))
  wiz_pinned_version  = local.wiz_member_template.Parameters.WizVersionLastUpdated.Default
}

# Warns, without failing the plan, when Wiz's published file differs from the
# committed copy.
module "wiz_upstream_check" {
  source = "./upstream-check"

  url               = "https://wizio-public.s3.amazonaws.com/deployment-v2/aws/wiz-aws-standard.json"
  committed_sha256  = filesha256(local.wiz_template_path)
  committed_version = local.wiz_pinned_version
}

# Exact vendor member-account template follows. Keep CloudFormation logical IDs
# stable across updates. $${...} escapes HCL interpolation for Fn::Sub strings.
# A precondition fails the plan unless this equals wiz-aws-standard.json.

locals {
  wiz_member_template = {
    "AWSTemplateFormatVersion" = "2010-09-09"
    "Conditions" = {
      "CloudCostScanning" = {
        "Fn::Equals" = [
          {
            "Ref" = "CloudCostScanning"
          },
          "Enabled",
        ]
      }
      "CreateDefendPolicy" = {
        "Fn::Or" = [
          {
            "Fn::Equals" = [
              {
                "Ref" = "S3AWSLogsScanning"
              },
              "Enabled",
            ]
          },
          {
            "Fn::Equals" = [
              {
                "Ref" = "RDSLogsScanning"
              },
              "Enabled",
            ]
          },
          {
            "Fn::Equals" = [
              {
                "Ref" = "S3KMSDecrypt"
              },
              "Enabled",
            ]
          },
        ]
      }
      "DataScanningEnabled" = {
        "Fn::Equals" = [
          {
            "Ref" = "DataScanning"
          },
          "Enabled",
        ]
      }
      "EKSScanningEnabled" = {
        "Fn::Equals" = [
          {
            "Ref" = "EKSScanning"
          },
          "Enabled",
        ]
      }
      "LightsailScanningEnabled" = {
        "Fn::Equals" = [
          {
            "Ref" = "LightsailScanning"
          },
          "Enabled",
        ]
      }
      "RDSLogsScanning" = {
        "Fn::Equals" = [
          {
            "Ref" = "RDSLogsScanning"
          },
          "Enabled",
        ]
      }
      "S3AWSLogsScanning" = {
        "Fn::Equals" = [
          {
            "Ref" = "S3AWSLogsScanning"
          },
          "Enabled",
        ]
      }
      "S3InventoryScanning" = {
        "Fn::Equals" = [
          {
            "Ref" = "S3InventoryScanning"
          },
          "Enabled",
        ]
      }
      "S3KMSDecrypt" = {
        "Fn::Equals" = [
          {
            "Ref" = "S3KMSDecrypt"
          },
          "Enabled",
        ]
      }
      "TerraformBucketScanning" = {
        "Fn::Equals" = [
          {
            "Ref" = "TerraformBucketScanning"
          },
          "Enabled",
        ]
      }
      "UsePermissionBoundary" = {
        "Fn::Not" = [
          {
            "Fn::Equals" = [
              {
                "Ref" = "PermissionBoundaryPolicyName"
              },
              "",
            ]
          },
        ]
      }
      "UseRolePath" = {
        "Fn::Not" = [
          {
            "Fn::Equals" = [
              {
                "Ref" = "RolePath"
              },
              "/",
            ]
          },
        ]
      }
      "UseRootStackFilename" = {
        "Fn::Not" = [
          {
            "Fn::Equals" = [
              {
                "Ref" = "WizRootStackFilename"
              },
              "",
            ]
          },
        ]
      }
      "UseRootStackId" = {
        "Fn::Not" = [
          {
            "Fn::Equals" = [
              {
                "Ref" = "WizRootStackId"
              },
              "",
            ]
          },
        ]
      }
    }
    "Description" = "Wiz AWS standard deployment"
    "Metadata" = {
      "AWS::CloudFormation::Interface" = {
        "ParameterGroups" = [
          {
            "Label" = {
              "default" = "Wiz Access Role"
            }
            "Parameters" = [
              "WizRoleName",
              "ExternalId",
              "RoleARN",
              "LightsailScanning",
              "DataScanning",
              "EKSScanning",
              "WizPolicyNameSuffix",
              "TerraformBucketScanning",
              "PermissionBoundaryPolicyName",
              "RolePath",
            ]
          },
          {
            "Label" = {
              "default" = "Wiz Defend"
            }
            "Parameters" = [
              "S3AWSLogsScanning",
              "RDSLogsScanning",
              "S3KMSDecrypt",
            ]
          },
          {
            "Label" = {
              "default" = "S3 Inventory Configuration"
            }
            "Parameters" = [
              "S3InventoryScanning",
            ]
          },
          {
            "Label" = {
              "default" = "Wiz Cloud Cost"
            }
            "Parameters" = [
              "CloudCostScanning",
            ]
          },
          {
            "Label" = {
              "default" = "Versioning"
            }
            "Parameters" = [
              "WizVersionLastUpdated",
              "WizRootStackId",
              "WizRootStackFilename",
            ]
          },
        ]
        "ParameterLabels" = {
          "DataScanning" = {
            "default" = "Enable Data Scanning"
          }
          "EKSScanning" = {
            "default" = "Enable EKS scanning"
          }
          "ExternalId" = {
            "default" = "Connector External ID"
          }
          "LightsailScanning" = {
            "default" = "Enable Lightsail Scanning"
          }
          "RDSLogsScanning" = {
            "default" = "Enable RDS Logs Scanning"
          }
          "RoleARN" = {
            "default" = "AWS Trust Policy Role"
          }
          "S3AWSLogsScanning" = {
            "default" = "Enable S3 AWS Logs Scanning"
          }
          "S3InventoryScanning" = {
            "default" = "Enable S3 Inventory Scanning"
          }
          "S3KMSDecrypt" = {
            "default" = "Enable S3 KMS Decrypt"
          }
          "WizRoleName" = {
            "default" = "Wiz Role Name"
          }
        }
      }
      "Tags" = [
        {
          "wiz_file_name"            = "aws/wiz-aws-standard.json"
          "wiz_version_last_updated" = "2026-10-21"
        },
      ]
    }
    "Outputs" = {
      "ExternalID" = {
        "Description" = "Your External ID"
        "Value" = {
          "Ref" = "ExternalId"
        }
      }
      "RoleARNID" = {
        "Description" = "Your Role ARN ID"
        "Value" = {
          "Fn::GetAtt" = [
            "Role",
            "Arn",
          ]
        }
      }
    }
    "Parameters" = {
      "CloudCostScanning" = {
        "AllowedValues" = [
          "Enabled",
          "Disabled",
        ]
        "Default"     = "Enabled"
        "Description" = "Enable Wiz Cloud Cost scanning"
        "Type"        = "String"
      }
      "DataScanning" = {
        "AllowedValues" = [
          "Enabled",
          "Disabled",
        ]
        "Default"     = "Disabled"
        "Description" = "Enable data scanning"
        "Type"        = "String"
      }
      "EKSScanning" = {
        "AllowedValues" = [
          "Enabled",
          "Disabled",
        ]
        "Default"     = "Disabled"
        "Description" = "Allow the Wiz access role to automatically connect to EKS clusters that have public API endpoints"
        "Type"        = "String"
      }
      "ExternalId" = {
        "AllowedPattern" = "\\S{8}-\\S{4}-\\S{4}-\\S{4}-\\S{12}"
        "Description"    = "Enter the External ID of the Wiz connector. This is a nonce that will be used by our service to assume the role in your account."
        "Type"           = "String"
      }
      "LightsailScanning" = {
        "AllowedValues" = [
          "Enabled",
          "Disabled",
        ]
        "Default"     = "Disabled"
        "Description" = "Enable lightsail scanning"
        "Type"        = "String"
      }
      "PermissionBoundaryPolicyName" = {
        "Default"     = ""
        "Description" = "Optional permission boundary policy name which will be applied to the Wiz IAM access role. Please note that this permission boundary policy must already exist in every AWS account where the Wiz IAM roles will be deployed."
        "Type"        = "String"
      }
      "RDSLogsScanning" = {
        "AllowedValues" = [
          "Enabled",
          "Disabled",
        ]
        "Default"     = "Enabled"
        "Description" = "Enable RDS logs scanning"
        "Type"        = "String"
      }
      "RoleARN" = {
        "AllowedPattern" = "arn:aws(-us-gov|-cn)?:iam::[0-9]+:role/.*"
        "Description"    = "Enter the AWS Trust Policy Role ARN for your Wiz data center. You can retrieve it from User Settings, Tenant in the Wiz portal."
        "Type"           = "String"
      }
      "RolePath" = {
        "AllowedPattern" = "(\\/)|(\\/[!-~]+\\/)"
        "Default"        = "/"
        "Description"    = "The path for the IAM role. Useful for organizing roles under a specific path (e.g., /governance/). Must start and end with /."
        "Type"           = "String"
      }
      "S3AWSLogsScanning" = {
        "AllowedValues" = [
          "Enabled",
          "Disabled",
        ]
        "Default"     = "Enabled"
        "Description" = "Enable retrieval of AWSLogs/* objects from S3 buckets"
        "Type"        = "String"
      }
      "S3InventoryScanning" = {
        "AllowedValues" = [
          "Enabled",
          "Disabled",
        ]
        "Default"     = "Disabled"
        "Description" = "Enable S3 inventory configuration scanning to discover and analyze S3 bucket inventory configurations. Disabled by default."
        "Type"        = "String"
      }
      "S3KMSDecrypt" = {
        "AllowedValues" = [
          "Enabled",
          "Disabled",
        ]
        "Default"     = "Enabled"
        "Description" = "Enable S3 KMS decrypt"
        "Type"        = "String"
      }
      "TerraformBucketScanning" = {
        "AllowedValues" = [
          "Enabled",
          "Disabled",
        ]
        "Default"     = "Enabled"
        "Description" = "Enable Cloud to Code scanning of buckets containing Terraform infrastructure files"
        "Type"        = "String"
      }
      "WizPolicyNameSuffix" = {
        "Default"     = ""
        "Description" = "(Optional) Add a suffix to every IAM policy name. This is helpful in the event you are deploying multiple instances of the same stack"
        "Type"        = "String"
      }
      "WizRoleName" = {
        "Default"     = "WizAccess-Role"
        "Description" = "Enter the IAM role name that will be created in your AWS account, the default is WizAccess-Role"
        "Type"        = "String"
      }
      "WizRootStackFilename" = {
        "Default"     = ""
        "Description" = "The root stack filename from org deployments. Leave empty for standalone deployments."
        "Type"        = "String"
      }
      "WizRootStackId" = {
        "Default"     = ""
        "Description" = "The root stack ID from org deployments. Leave empty for standalone deployments."
        "Type"        = "String"
      }
      "WizVersionLastUpdated" = {
        "Default"     = "2026-10-21"
        "Description" = "Auto-generated. No modification needed."
        "Type"        = "String"
      }
    }
    "Resources" = {
      "Role" = {
        "Properties" = {
          "AssumeRolePolicyDocument" = {
            "Statement" = [
              {
                "Action" = "sts:AssumeRole"
                "Condition" = {
                  "StringEquals" = {
                    "sts:ExternalId" = {
                      "Ref" = "ExternalId"
                    }
                  }
                }
                "Effect" = "Allow"
                "Principal" = {
                  "AWS" = {
                    "Ref" = "RoleARN"
                  }
                }
              },
            ]
            "Version" = "2012-10-17"
          }
          "ManagedPolicyArns" = [
            {
              "Fn::Sub" = "arn:$${AWS::Partition}:iam::aws:policy/job-function/ViewOnlyAccess"
            },
            {
              "Fn::Sub" = "arn:$${AWS::Partition}:iam::aws:policy/SecurityAudit"
            },
          ]
          "Path" = {
            "Fn::If" = [
              "UseRolePath",
              {
                "Ref" = "RolePath"
              },
              {
                "Ref" = "AWS::NoValue"
              },
            ]
          }
          "PermissionsBoundary" = {
            "Fn::If" = [
              "UsePermissionBoundary",
              {
                "Fn::Sub" = "arn:$${AWS::Partition}:iam::$${AWS::AccountId}:policy/$${PermissionBoundaryPolicyName}"
              },
              {
                "Ref" = "AWS::NoValue"
              },
            ]
          }
          "RoleName" = {
            "Ref" = "WizRoleName"
          }
          "Tags" = [
            {
              "Key" = "wiz_version_last_updated"
              "Value" = {
                "Ref" = "WizVersionLastUpdated"
              }
            },
            {
              "Key" = "wiz_stack_name"
              "Value" = {
                "Ref" = "AWS::StackName"
              }
            },
            {
              "Key" = "wiz_stack_id"
              "Value" = {
                "Fn::If" = [
                  "UseRootStackId",
                  {
                    "Ref" = "WizRootStackId"
                  },
                  {
                    "Ref" = "AWS::StackId"
                  },
                ]
              }
            },
            {
              "Key" = "wiz_stack_region"
              "Value" = {
                "Ref" = "AWS::Region"
              }
            },
            {
              "Key" = "wiz_stack_filename"
              "Value" = {
                "Fn::If" = [
                  "UseRootStackFilename",
                  {
                    "Ref" = "WizRootStackFilename"
                  },
                  "aws/wiz-aws-standard.json",
                ]
              }
            },
          ]
        }
        "Type" = "AWS::IAM::Role"
      }
      "WizCloudCostPolicy" = {
        "Condition" = "CloudCostScanning"
        "Properties" = {
          "ManagedPolicyName" = {
            "Fn::Sub" = "WizCloudCostPolicy$${WizPolicyNameSuffix}"
          }
          "PolicyDocument" = {
            "Statement" = [
              {
                "Action" = [
                  "trustedadvisor:ListChecks",
                  "trustedadvisor:ListRecommendationResources",
                  "trustedadvisor:ListRecommendations",
                ]
                "Effect"   = "Allow"
                "Resource" = "*"
                "Sid"      = "AllowWizToCollectTrustedAdvisorRecommendations"
              },
              {
                "Action" = [
                  "compute-optimizer:GetAutoScalingGroupRecommendations",
                  "compute-optimizer:GetEBSVolumeRecommendations",
                  "compute-optimizer:GetEC2InstanceRecommendations",
                  "compute-optimizer:GetECSServiceRecommendations",
                  "compute-optimizer:GetEnrollmentStatus",
                  "compute-optimizer:GetEnrollmentStatusesForOrganization",
                  "compute-optimizer:GetIdleRecommendations",
                  "compute-optimizer:GetLambdaFunctionRecommendations",
                  "compute-optimizer:GetLicenseRecommendations",
                  "compute-optimizer:GetRDSDatabaseRecommendations",
                  "compute-optimizer:GetRecommendationSummaries",
                ]
                "Effect"   = "Allow"
                "Resource" = "*"
                "Sid"      = "AllowWizToViewComputeOptimizerRecommendations"
              },
            ]
            "Version" = "2012-10-17"
          }
          "Roles" = [
            {
              "Ref" = "Role"
            },
          ]
        }
        "Type" = "AWS::IAM::ManagedPolicy"
      }
      "WizDataScanningPolicy" = {
        "Condition" = "DataScanningEnabled"
        "Properties" = {
          "ManagedPolicyName" = {
            "Fn::Sub" = "WizDataScanningPolicy$${WizPolicyNameSuffix}"
          }
          "PolicyDocument" = {
            "Statement" = [
              {
                "Action" = [
                  "redshift:AuthorizeSnapshotAccess",
                  "redshift:DeleteClusterSnapshot",
                  "redshift:RevokeSnapshotAccess",
                ]
                "Effect" = "Allow"
                "Resource" = {
                  "Fn::Sub" = "arn:$${AWS::Partition}:redshift:*:*:snapshot:*wiz-autogen-*"
                }
              },
              {
                "Action" = [
                  "redshift:CreateTags",
                ]
                "Effect" = "Allow"
                "Resource" = {
                  "Fn::Sub" = "arn:$${AWS::Partition}:redshift:*:*:snapshot:*/*"
                }
              },
              {
                "Action" = [
                  "redshift:CreateClusterSnapshot",
                ]
                "Condition" = {
                  "StringEquals" = {
                    "aws:RequestTag/wiz" = "auto-gen-snapshot"
                  }
                }
                "Effect"   = "Allow"
                "Resource" = "*"
              },
              {
                "Action" = [
                  "dynamodb:DescribeTable",
                  "dynamodb:Scan",
                  "rds:AddTagsToResource",
                  "rds:CopyDBClusterSnapshot",
                  "rds:CopyDBSnapshot",
                  "rds:DescribeAccountAttributes",
                  "rds:DescribeDBClusterSnapshots",
                  "rds:DescribeDBClusters",
                  "rds:DescribeDBInstances",
                  "rds:DescribeDBSnapshots",
                  "rds:DescribeDBSubnetGroups",
                  "rds:ListTagsForResource",
                  "redshift:CopyClusterSnapshot",
                  "redshift:DescribeClusterSnapshots",
                  "redshift:DescribeClusters",
                  "s3:GetObject",
                  "s3:ListBucket",
                ]
                "Effect"   = "Allow"
                "Resource" = "*"
              },
              {
                "Action" = [
                  "rds:DeleteDBClusterSnapshot",
                  "rds:ModifyDBClusterSnapshotAttribute",
                ]
                "Effect" = "Allow"
                "Resource" = {
                  "Fn::Sub" = "arn:$${AWS::Partition}:rds:*:*:cluster-snapshot:wiz-autogen-*"
                }
              },
              {
                "Action" = [
                  "rds:DeleteDBSnapshot",
                  "rds:ModifyDBSnapshotAttribute",
                ]
                "Effect" = "Allow"
                "Resource" = {
                  "Fn::Sub" = "arn:$${AWS::Partition}:rds:*:*:snapshot:wiz-autogen-*"
                }
              },
              {
                "Action" = [
                  "rds:CreateDBClusterSnapshot",
                  "rds:CreateDBSnapshot",
                ]
                "Condition" = {
                  "StringEquals" = {
                    "rds:req-tag/wiz" = "auto-gen-snapshot"
                  }
                }
                "Effect"   = "Allow"
                "Resource" = "*"
              },
              {
                "Action" = [
                  "kms:CreateGrant",
                  "kms:ReEncrypt*",
                ]
                "Condition" = {
                  "StringLike" = {
                    "kms:ViaService" = {
                      "Fn::Sub" = "rds.*.$${AWS::URLSuffix}"
                    }
                  }
                }
                "Effect"   = "Allow"
                "Resource" = "*"
              },
              {
                "Action" = [
                  "kms:CreateGrant",
                ]
                "Condition" = {
                  "StringLike" = {
                    "kms:ViaService" = {
                      "Fn::Sub" = "redshift.*.$${AWS::URLSuffix}"
                    }
                  }
                }
                "Effect"   = "Allow"
                "Resource" = "*"
              },
            ]
            "Version" = "2012-10-17"
          }
          "Roles" = [
            {
              "Ref" = "Role"
            },
          ]
        }
        "Type" = "AWS::IAM::ManagedPolicy"
      }
      "WizDefendPolicy" = {
        "Condition" = "CreateDefendPolicy"
        "Properties" = {
          "ManagedPolicyName" = {
            "Fn::Sub" = "WizDefendPolicy$${WizPolicyNameSuffix}"
          }
          "PolicyDocument" = {
            "Statement" = [
              {
                "Fn::If" = [
                  "RDSLogsScanning",
                  {
                    "Action" = [
                      "rds:DownloadCompleteDBLogFile",
                      "rds:DownloadDBLogFilePortion",
                    ]
                    "Effect" = "Allow"
                    "Resource" = {
                      "Fn::Sub" = "arn:$${AWS::Partition}:rds:*:*:db:*"
                    }
                    "Sid" = "WizRDSLogsAccess"
                  },
                  {
                    "Ref" = "AWS::NoValue"
                  },
                ]
              },
              {
                "Fn::If" = [
                  "S3AWSLogsScanning",
                  {
                    "Action" = [
                      "s3:GetObject",
                      "s3:GetObjectAttributes",
                      "s3:GetObjectRetention",
                    ]
                    "Effect" = "Allow"
                    "Resource" = [
                      {
                        "Fn::Sub" = "arn:$${AWS::Partition}:s3:::*/AWSLogs/*"
                      },
                      {
                        "Fn::Sub" = "arn:$${AWS::Partition}:s3:::*/*/AWSLogs/*"
                      },
                    ]
                    "Sid" = "WizS3AWSLogsGetObject"
                  },
                  {
                    "Ref" = "AWS::NoValue"
                  },
                ]
              },
              {
                "Fn::If" = [
                  "S3AWSLogsScanning",
                  {
                    "Action" = [
                      "s3:ListBucket",
                    ]
                    "Condition" = {
                      "StringLike" = {
                        "s3:prefix" = [
                          "AWSLogs/*",
                          "*/AWSLogs/*",
                        ]
                      }
                    }
                    "Effect" = "Allow"
                    "Resource" = [
                      {
                        "Fn::Sub" = "arn:$${AWS::Partition}:s3:::*"
                      },
                    ]
                    "Sid" = "WizS3AWSLogsListBucket"
                  },
                  {
                    "Ref" = "AWS::NoValue"
                  },
                ]
              },
              {
                "Fn::If" = [
                  "S3KMSDecrypt",
                  {
                    "Action" = [
                      "kms:Decrypt",
                    ]
                    "Condition" = {
                      "StringLike" = {
                        "kms:ViaService" = {
                          "Fn::Sub" = "s3.*.$${AWS::URLSuffix}"
                        }
                      }
                    }
                    "Effect" = "Allow"
                    "Resource" = {
                      "Fn::Sub" = "arn:$${AWS::Partition}:kms:*:*:key/*"
                    }
                    "Sid" = "WizS3KMSDecrypt"
                  },
                  {
                    "Ref" = "AWS::NoValue"
                  },
                ]
              },
            ]
            "Version" = "2012-10-17"
          }
          "Roles" = [
            {
              "Ref" = "Role"
            },
          ]
        }
        "Type" = "AWS::IAM::ManagedPolicy"
      }
      "WizEKSScanningPolicy" = {
        "Condition" = "EKSScanningEnabled"
        "Properties" = {
          "PolicyDocument" = {
            "Statement" = [
              {
                "Action" = [
                  "eks:CreateAccessEntry",
                ]
                "Condition" = {
                  "StringEquals" = {
                    "eks:principalArn" = {
                      "Fn::Sub" = "arn:$${AWS::Partition}:iam::$${AWS::AccountId}:role/$${WizRoleName}"
                    }
                  }
                }
                "Effect" = "Allow"
                "Resource" = [
                  "*",
                ]
                "Sid" = "WizCreateAccessEntry"
              },
              {
                "Action" = [
                  "eks:DeleteAccessEntry",
                ]
                "Condition" = {
                  "StringEquals" = {
                    "aws:ResourceTag/CreatedBy" = "Wiz"
                  }
                }
                "Effect" = "Allow"
                "Resource" = [
                  "*",
                ]
                "Sid" = "WizDeleteAccessEntry"
              },
              {
                "Action" = [
                  "eks:TagResource",
                ]
                "Condition" = {}
                "Effect"    = "Allow"
                "Resource" = [
                  {
                    "Fn::Sub" = "arn:$${AWS::Partition}:eks:*:*:access-entry/*/role/$${AWS::AccountId}/$${WizRoleName}/*"
                  },
                ]
                "Sid" = "WizTagAccessEntry"
              },
              {
                "Action" = [
                  "eks:AssociateAccessPolicy",
                ]
                "Condition" = {
                  "StringEquals" = {
                    "eks:policyArn" = {
                      "Fn::Sub" = "arn:$${AWS::Partition}:eks::aws:cluster-access-policy/AmazonEKSAdminViewPolicy"
                    }
                    "eks:principalArn" = {
                      "Fn::Sub" = "arn:$${AWS::Partition}:iam::$${AWS::AccountId}:role/$${WizRoleName}"
                    }
                  }
                }
                "Effect" = "Allow"
                "Resource" = [
                  "*",
                ]
                "Sid" = "WizAssociateViewOnly"
              },
            ]
            "Version" = "2012-10-17"
          }
          "PolicyName" = {
            "Fn::Sub" = "WizEKSScanningPolicy$${WizPolicyNameSuffix}"
          }
          "Roles" = [
            {
              "Ref" = "Role"
            },
          ]
        }
        "Type" = "AWS::IAM::Policy"
      }
      "WizFullPolicy" = {
        "Properties" = {
          "PolicyDocument" = {
            "Statement" = [
              {
                "Action" = [
                  "account:GetContactInformation",
                  "acm-pca:GetCertificateAuthorityCertificate",
                  "acm:GetCertificate",
                  "aiops:ListTagsForResource",
                  "amplify:GetApp",
                  "amplify:GetBackendEnvironment",
                  "amplify:ListApps",
                  "amplify:ListBackendEnvironments",
                  "amplify:ListBranches",
                  "amplify:ListDomainAssociations",
                  "amplify:ListTagsForResource",
                  "amplifybackend:GetBackend",
                  "aoss:BatchGetCollection",
                  "aoss:GetAccessPolicy",
                  "aoss:GetSecurityPolicy",
                  "aoss:ListAccessPolicies",
                  "aoss:ListCollections",
                  "aoss:ListSecurityPolicies",
                  "aoss:ListTagsForResource",
                  "apigateway:GET",
                  "apigateway:GetPortal",
                  "apigateway:GetPortalProduct",
                  "apigateway:GetProductPage",
                  "apigateway:ListPortalProducts",
                  "apigateway:ListPortals",
                  "apigateway:ListProductPages",
                  "app-integrations:GetApplication",
                  "app-integrations:GetDataIntegration",
                  "app-integrations:ListApplications",
                  "app-integrations:ListDataIntegrations",
                  "app-integrations:ListEventIntegrations",
                  "appconfig:GetConfigurationProfile",
                  "appconfig:GetDeployment",
                  "appconfig:GetExtension",
                  "appconfig:GetExtensionAssociation",
                  "appconfig:ListApplications",
                  "appconfig:ListConfigurationProfiles",
                  "appconfig:ListDeploymentStrategies",
                  "appconfig:ListDeployments",
                  "appconfig:ListEnvironments",
                  "appconfig:ListExtensionAssociations",
                  "appconfig:ListExtensions",
                  "appconfig:ListTagsForResource",
                  "appfabric:GetAppAuthorization",
                  "appfabric:GetAppBundle",
                  "appfabric:ListAppAuthorizations",
                  "appfabric:ListAppBundles",
                  "appfabric:ListTagsForResource",
                  "appflow:DescribeConnector",
                  "appflow:DescribeConnectorProfiles",
                  "appflow:DescribeFlow",
                  "appflow:ListConnectors",
                  "applicationinsights:ListApplications",
                  "applicationinsights:ListTagsForResource",
                  "apprunner:ListAssociatedServicesForWebAcl",
                  "appstream:DescribeAppBlockBuilders",
                  "appstream:DescribeAppBlocks",
                  "appstream:DescribeFleets",
                  "appstream:DescribeImageBuilders",
                  "appstream:DescribeImages",
                  "appstream:DescribeStacks",
                  "appstream:DescribeUserStackAssociations",
                  "appstream:ListAssociatedFleets",
                  "appstream:ListTagsForResource",
                  "appsync:GetApiAssociation",
                  "aps:DescribeAlertManagerDefinition",
                  "aps:DescribeLoggingConfiguration",
                  "aps:DescribeScraper",
                  "aps:ListScrapers",
                  "aps:ListWorkspaces",
                  "athena:GetDataCatalog",
                  "auditmanager:GetAssessment",
                  "auditmanager:GetControl",
                  "b2bi:GetCapability",
                  "b2bi:GetPartnership",
                  "b2bi:GetProfile",
                  "b2bi:GetTransformer",
                  "b2bi:ListCapabilities",
                  "b2bi:ListPartnerships",
                  "b2bi:ListProfiles",
                  "b2bi:ListTagsForResource",
                  "b2bi:ListTransformers",
                  "backup-gateway:GetGateway",
                  "backup-gateway:GetHypervisor",
                  "backup-gateway:ListGateways",
                  "backup-gateway:ListHypervisors",
                  "backup-gateway:ListTagsForResource",
                  "backup-search:GetSearchJob",
                  "backup-search:GetSearchResultExportJob",
                  "backup-search:ListSearchJobs",
                  "backup-search:ListSearchResultExportJobs",
                  "backup-search:ListTagsForResource",
                  "backup:GetBackupPlan",
                  "backup:GetBackupSelection",
                  "backup:GetLegalHold",
                  "backup:GetRestoreTestingPlan",
                  "backup:GetTieringConfiguration",
                  "backup:ListRestoreTestingPlans",
                  "backup:ListTieringConfigurations",
                  "batch:DescribeConsumableResource",
                  "batch:DescribeJobQueues",
                  "batch:DescribeServiceEnvironments",
                  "batch:DescribeServiceJob",
                  "batch:ListConsumableResources",
                  "batch:ListServiceJobs",
                  "bedrock-agentcore:GetBrowserSession",
                  "bedrock-agentcore:GetResourcePolicy",
                  "bedrock-agentcore:GetTokenVault",
                  "bedrock-agentcore:ListBrowserSessions",
                  "bedrock-agentcore:ListHarnessEndpoints",
                  "bedrock-agentcore:ListHarnessVersions",
                  "bedrock-agentcore:ListMemoryExtractionJobs",
                  "bedrock-agentcore:ListMemoryRecords",
                  "bedrock-agentcore:ListPolicyEngineSummaries",
                  "bedrock:GetAgent",
                  "bedrock:GetAgentActionGroup",
                  "bedrock:GetAgentVersion",
                  "bedrock:GetDataSource",
                  "bedrock:GetGuardrail",
                  "bedrock:GetKnowledgeBase",
                  "bedrock:ListAgentCollaborators",
                  "bedrock:ListEnforcedGuardrailsConfiguration",
                  "chatbot:DescribeChimeWebhookConfigurations",
                  "chatbot:DescribeSlackChannelConfigurations",
                  "chime:GetAccount",
                  "chime:GetVoiceConnector",
                  "cleanrooms-ml:GetAudienceGenerationJob",
                  "cleanrooms-ml:GetAudienceModel",
                  "cleanrooms-ml:GetConfiguredAudienceModel",
                  "cleanrooms-ml:GetConfiguredModelAlgorithm",
                  "cleanrooms-ml:ListAudienceGenerationJobs",
                  "cleanrooms-ml:ListAudienceModels",
                  "cleanrooms-ml:ListConfiguredAudienceModels",
                  "cleanrooms-ml:ListConfiguredModelAlgorithms",
                  "clouddirectory:ListTagsForResource",
                  "cloudhsm:DescribeClusters",
                  "cloudsearch:DescribeAvailabilityOptions",
                  "codeartifact:DescribeDomain",
                  "codeartifact:DescribeRepository",
                  "codeartifact:GetAuthorizationToken",
                  "codeartifact:ListDomains",
                  "codeartifact:ListPackageVersions",
                  "codeartifact:ListPackages",
                  "codeartifact:ListTagsForResource",
                  "codeartifact:ReadFromRepository",
                  "codeconnections:ListConnections",
                  "codeconnections:ListHosts",
                  "codeconnections:ListTagsForResource",
                  "codeguru-profiler:ListProfilingGroups",
                  "codeguru-reviewer:DescribeRepositoryAssociation",
                ]
                "Effect"   = "Allow"
                "Resource" = "*"
                "Sid"      = "WizFullPolicy"
              },
              {
                "Action" = "cassandra:Select"
                "Effect" = "Allow"
                "Resource" = [
                  {
                    "Fn::Sub" = "arn:$${AWS::Partition}:cassandra:*:*:/keyspace/system_schema/table/keyspaces"
                  },
                  {
                    "Fn::Sub" = "arn:$${AWS::Partition}:cassandra:*:*:/keyspace/system_schema/table/tables"
                  },
                  {
                    "Fn::Sub" = "arn:$${AWS::Partition}:cassandra:*:*:/keyspace/system_schema/table/columns"
                  },
                  {
                    "Fn::Sub" = "arn:$${AWS::Partition}:cassandra:*:*:/keyspace/system_schema_mcs/table/keyspaces"
                  },
                  {
                    "Fn::Sub" = "arn:$${AWS::Partition}:cassandra:*:*:/keyspace/system_schema_mcs/table/tables"
                  },
                  {
                    "Fn::Sub" = "arn:$${AWS::Partition}:cassandra:*:*:/keyspace/system_schema_mcs/table/columns"
                  },
                  {
                    "Fn::Sub" = "arn:$${AWS::Partition}:cassandra:*:*:/keyspace/system_schema_mcs/table/tags"
                  },
                  {
                    "Fn::Sub" = "arn:$${AWS::Partition}:cassandra:*:*:/keyspace/system_multiregion_info/table/tables"
                  },
                ]
              },
              {
                "Action" = [
                  "kms:Decrypt",
                  "kms:GenerateDataKey",
                ]
                "Condition" = {
                  "StringLike" = {
                    "kms:ViaService" = "bedrock.*.amazonaws.com"
                  }
                }
                "Effect"   = "Allow"
                "Resource" = "*"
              },
              {
                "Action" = [
                  "kms:Decrypt",
                ]
                "Condition" = {
                  "StringLike" = {
                    "kms:ViaService" = "identitystore.*.amazonaws.com"
                  }
                }
                "Effect"   = "Allow"
                "Resource" = "*"
              },
              {
                "Action" = [
                  "ecr-public:DescribeImages",
                  "ecr-public:GetAuthorizationToken",
                  "ecr-public:ListTagsForResource",
                  "ecr:BatchGetImage",
                  "ecr:DescribeImages",
                  "ecr:GetAuthorizationToken",
                  "ecr:GetDownloadUrlForLayer",
                  "ecr:GetRegistryPolicy",
                  "ecr:ListTagsForResource",
                ]
                "Effect"   = "Allow"
                "Resource" = "*"
              },
              {
                "Action" = [
                  "ec2:CopySnapshot",
                  "ec2:CreateSnapshot",
                  "ec2:DescribeSnapshots",
                  "ec2:GetEbsEncryptionByDefault",
                  "kms:CreateKey",
                  "kms:DescribeKey",
                ]
                "Effect"   = "Allow"
                "Resource" = "*"
              },
              {
                "Action" = [
                  "ec2:CreateTags",
                ]
                "Condition" = {
                  "StringEquals" = {
                    "ec2:CreateAction" = [
                      "CreateSnapshot",
                      "CopySnapshot",
                    ]
                  }
                }
                "Effect" = "Allow"
                "Resource" = {
                  "Fn::Sub" = "arn:$${AWS::Partition}:ec2:*::snapshot/*"
                }
                "Sid" = "AllowWizToCreateTagsOnCreatedAndCopiedSnapshots"
              },
              {
                "Action" = "kms:CreateAlias"
                "Effect" = "Allow"
                "Resource" = [
                  {
                    "Fn::Sub" = "arn:$${AWS::Partition}:kms:*:*:alias/wizKey"
                  },
                  {
                    "Fn::Sub" = "arn:$${AWS::Partition}:kms:*:*:key/*"
                  },
                ]
              },
              {
                "Action" = [
                  "kms:CreateGrant",
                  "kms:ReEncryptFrom",
                ]
                "Condition" = {
                  "StringLike" = {
                    "kms:ViaService" = "ec2.*.amazonaws.com"
                  }
                }
                "Effect"   = "Allow"
                "Resource" = "*"
              },
              {
                "Action" = [
                  "kms:GetKeyPolicy",
                  "kms:PutKeyPolicy",
                ]
                "Condition" = {
                  "StringEquals" = {
                    "aws:ResourceTag/wiz" = "auto-gen-cmk"
                  }
                }
                "Effect"   = "Allow"
                "Resource" = "*"
              },
              {
                "Action" = [
                  "ec2:DeleteSnapshot",
                ]
                "Condition" = {
                  "StringEquals" = {
                    "ec2:ResourceTag/wiz" = "auto-gen-snapshot"
                  }
                }
                "Effect"   = "Allow"
                "Resource" = "*"
              },
              {
                "Action" = [
                  "ec2:ModifySnapshotAttribute",
                ]
                "Condition" = {
                  "StringEquals" = {
                    "ec2:ResourceTag/wiz" = [
                      "auto-gen-snapshot",
                      "shareable-resource",
                    ]
                  }
                }
                "Effect"   = "Allow"
                "Resource" = "*"
              },
              {
                "Action" = [
                  "ec2:CreateVolume",
                ]
                "Condition" = {
                  "StringEquals" = {
                    "aws:RequestTag/wiz" = "auto-gen-volume"
                  }
                }
                "Effect"   = "Allow"
                "Resource" = "*"
                "Sid"      = "AllowWizToCreateTaggedVolumes"
              },
              {
                "Action" = "ec2:CreateTags"
                "Condition" = {
                  "StringEquals" = {
                    "ec2:CreateAction" = "CreateVolume"
                  }
                }
                "Effect"   = "Allow"
                "Resource" = "*"
                "Sid"      = "AllowWizToCreateTagsOnCreatedVolumes"
              },
              {
                "Action" = [
                  "ec2:CreateVolume",
                ]
                "Effect" = "Allow"
                "Resource" = {
                  "Fn::Sub" = "arn:$${AWS::Partition}:ec2:*::snapshot/*"
                }
                "Sid" = "AllowWizToCreateTaggedVolumesFromSnapshots"
              },
              {
                "Action" = [
                  "ec2:DeleteVolume",
                ]
                "Condition" = {
                  "StringEquals" = {
                    "ec2:ResourceTag/wiz" = "auto-gen-volume"
                  }
                }
                "Effect"   = "Allow"
                "Resource" = "*"
                "Sid"      = "AllowWizToDeleteTaggedVolumes"
              },
              {
                "Action" = [
                  "ec2:DescribeAvailabilityZones",
                  "ec2:DescribeVolumes",
                ]
                "Effect"   = "Allow"
                "Resource" = "*"
                "Sid"      = "WizComplementaryPermissionsForTemporaryVolumes"
              },
            ]
            "Version" = "2012-10-17"
          }
          "PolicyName" = {
            "Fn::Sub" = "WizFullPolicy$${WizPolicyNameSuffix}"
          }
          "Roles" = [
            {
              "Ref" = "Role"
            },
          ]
        }
        "Type" = "AWS::IAM::Policy"
      }
      "WizFullPolicy2" = {
        "Properties" = {
          "ManagedPolicyName" = {
            "Fn::Sub" = "WizFullPolicy2$${WizPolicyNameSuffix}"
          }
          "PolicyDocument" = {
            "Statement" = [
              {
                "Action" = [
                  "codeguru-reviewer:ListRepositoryAssociations",
                  "codepipeline:ListTagsForResource",
                  "codepipeline:ListWebhooks",
                  "codestar-notifications:DescribeNotificationRule",
                  "codestar-notifications:ListNotificationRules",
                  "databrew:DescribeJob",
                  "databrew:DescribeRecipe",
                  "databrew:ListRecipes",
                  "dataexchange:GetAsset",
                  "dataexchange:GetDataGrant",
                  "dataexchange:GetEventAction",
                  "dataexchange:GetRevision",
                  "dataexchange:ListDataGrants",
                  "dataexchange:ListDataSetRevisions",
                  "dataexchange:ListEventActions",
                  "dataexchange:ListJobs",
                  "dataexchange:ListRevisionAssets",
                  "dataexchange:ListTagsForResource",
                  "datazone:GetDomain",
                  "datazone:ListDomains",
                  "datazone:ListTagsForResource",
                  "detective:ListOrganizationAdminAccount",
                  "detective:ListTagsForResource",
                  "devops-guru:DescribeServiceIntegration",
                  "devops-guru:ListNotificationChannels",
                  "dlm:GetLifecyclePolicies",
                  "dlm:GetLifecyclePolicy",
                  "docdb-elastic:GetCluster",
                  "docdb-elastic:GetClusterSnapshot",
                  "docdb-elastic:ListClusterSnapshots",
                  "docdb-elastic:ListTagsForResource",
                  "drs:DescribeJobs",
                  "drs:DescribeLaunchConfigurationTemplates",
                  "drs:DescribeRecoveryInstances",
                  "drs:DescribeReplicationConfigurationTemplates",
                  "drs:DescribeSourceNetworks",
                  "drs:DescribeSourceServers",
                  "drs:GetRecoveryPlan",
                  "drs:ListRecoveryPlans",
                  "ds:DescribeEventTopics",
                  "ds:DescribeSettings",
                  "ds:DescribeSharedDirectories",
                  "ds:DescribeTrusts",
                  "ds:GetSnapshotLimits",
                  "ds:ListCertificates",
                  "ds:ListLogSubscriptions",
                  "ds:ListTagsForResource",
                  "dsql:GetCluster",
                  "dsql:ListClusters",
                  "ec2:GetVerifiedAccessEndpointPolicy",
                  "ecr:BatchGetImage",
                  "ecr:DescribePullThroughCacheRules",
                  "ecr:GetAuthorizationToken",
                  "ecr:GetDownloadUrlForLayer",
                  "eks:DescribeAccessEntry",
                  "eks:DescribeClusterVersions",
                  "eks:DescribePodIdentityAssociation",
                  "eks:ListPodIdentityAssociations",
                  "entityresolution:GetMatchingWorkflow",
                  "entityresolution:GetPolicy",
                  "entityresolution:GetSchemaMapping",
                  "entityresolution:ListIdNamespaces",
                  "entityresolution:ListMatchingWorkflows",
                  "entityresolution:ListSchemaMappings",
                  "entityresolution:ListTagsForResource",
                  "fis:GetExperiment",
                  "fis:GetExperimentTemplate",
                  "fis:ListActions",
                  "fis:ListExperimentTemplates",
                  "fis:ListExperiments",
                  "frauddetector:ListTagsForResource",
                  "gamelift:DescribeAlias",
                  "gamelift:DescribeBuild",
                  "gamelift:DescribeContainerFleet",
                  "gamelift:DescribeFleetAttributes",
                  "gamelift:DescribeFleetEvents",
                  "gamelift:DescribeGameServerGroup",
                  "gamelift:DescribeGameSessionQueues",
                  "gamelift:DescribeMatchmakingConfigurations",
                  "gamelift:DescribeMatchmakingRuleSets",
                  "gamelift:DescribeScript",
                  "geo:DescribeGeofenceCollection",
                  "geo:DescribeKey",
                  "geo:DescribeMap",
                  "geo:DescribePlaceIndex",
                  "geo:DescribeRouteCalculator",
                  "geo:DescribeTracker",
                  "geo:ListGeofenceCollections",
                  "geo:ListKeys",
                  "geo:ListPlaceIndexes",
                  "geo:ListRouteCalculators",
                  "geo:ListTagsForResource",
                  "geo:ListTrackers",
                  "glue:GetConnection",
                  "glue:GetConnections",
                  "glue:GetDatabase",
                  "glue:GetMLTransform",
                  "glue:GetMLTransforms",
                  "glue:GetTables",
                  "glue:GetTriggers",
                  "glue:GetWorkflow",
                  "glue:ListWorkflows",
                  "grafana:DescribeWorkspace",
                  "greengrass:DescribeComponent",
                  "greengrass:GetCoreDevice",
                  "greengrass:GetDeployment",
                  "healthlake:ListTagsForResource",
                  "identitystore:Describe*",
                  "identitystore:List*",
                  "imagebuilder:GetImage",
                  "imagebuilder:GetWorkflow",
                  "imagebuilder:ListComponentBuildVersions",
                  "imagebuilder:ListComponents",
                  "imagebuilder:ListContainerRecipes",
                  "imagebuilder:ListDistributionConfigurations",
                  "imagebuilder:ListImageBuildVersions",
                  "imagebuilder:ListImagePipelines",
                  "imagebuilder:ListImageRecipes",
                  "imagebuilder:ListImages",
                  "imagebuilder:ListInfrastructureConfigurations",
                  "imagebuilder:ListLifecyclePolicies",
                  "imagebuilder:ListTagsForResource",
                  "imagebuilder:ListWorkflowBuildVersions",
                  "imagebuilder:ListWorkflows",
                  "inspector2:GetCodeSecurityIntegration",
                  "inspector2:GetCodeSecurityScanConfiguration",
                  "inspector2:GetEc2DeepInspectionConfiguration",
                  "inspector2:ListCisScanConfigurations",
                  "inspector2:ListCodeSecurityIntegrations",
                  "inspector2:ListCodeSecurityScanConfigurations",
                  "internetmonitor:GetMonitor",
                  "internetmonitor:ListMonitors",
                  "internetmonitor:ListTagsForResource",
                  "iot:GetCommand",
                  "iot:GetOTAUpdate",
                  "iot:GetPackage",
                  "iot:GetPackageVersion",
                  "iot:GetTopicRule",
                  "iot:GetTopicRuleDestination",
                  "iotanalytics:DescribeChannel",
                  "iotanalytics:DescribeDataset",
                  "iotanalytics:DescribeDatastore",
                  "iotanalytics:DescribePipeline",
                  "iotanalytics:ListDatasets",
                  "iotanalytics:ListDatastores",
                  "iotanalytics:ListPipelines",
                  "iotanalytics:ListTagsForResource",
                  "iotfleetwise:GetCampaign",
                  "iotfleetwise:ListCampaigns",
                  "iotfleetwise:ListTagsForResource",
                  "iotsitewise:DescribeAssetModel",
                  "iotsitewise:DescribePortal",
                  "iotsitewise:ListPortals",
                  "iotsitewise:ListTagsForResource",
                  "iottwinmaker:GetComponentType",
                  "iottwinmaker:GetEntity",
                  "iottwinmaker:GetScene",
                  "iottwinmaker:GetSyncJob",
                  "iottwinmaker:GetWorkspace",
                  "iottwinmaker:ListComponentTypes",
                  "iottwinmaker:ListEntities",
                  "iottwinmaker:ListScenes",
                  "iottwinmaker:ListSyncJobs",
                  "iottwinmaker:ListTagsForResource",
                  "kendra:DescribeDataSource",
                  "kinesis:GetResourcePolicy",
                  "kinesisanalytics:DescribeApplication",
                  "kinesisvideo:GetDataEndpoint",
                  "lambda:GetFunction",
                  "lambda:GetLayerVersion",
                  "lex:DescribeBotVersion",
                  "lex:ListTagsForResource",
                  "lex:ListTestSets",
                  "lightsail:GetCertificates",
                  "lightsail:GetDiskSnapshot",
                ]
                "Effect"   = "Allow"
                "Resource" = "*"
                "Sid"      = "WizFullPolicy2"
              },
              {
                "Fn::If" = [
                  "S3InventoryScanning",
                  {
                    "Action" = [
                      "s3:GetInventoryConfiguration",
                      "s3:PutInventoryConfiguration",
                    ]
                    "Effect"   = "Allow"
                    "Resource" = "*"
                    "Sid"      = "WizS3InventoryAccess"
                  },
                  {
                    "Ref" = "AWS::NoValue"
                  },
                ]
              },
            ]
            "Version" = "2012-10-17"
          }
          "Roles" = [
            {
              "Ref" = "Role"
            },
          ]
        }
        "Type" = "AWS::IAM::ManagedPolicy"
      }
      "WizFullPolicy3" = {
        "Properties" = {
          "ManagedPolicyName" = {
            "Fn::Sub" = "WizFullPolicy3$${WizPolicyNameSuffix}"
          }
          "PolicyDocument" = {
            "Statement" = [
              {
                "Action" = [
                  "lightsail:GetDistributions",
                  "lightsail:GetDomain",
                  "lightsail:GetDomains",
                  "lightsail:GetInstanceSnapshot",
                  "lightsail:GetKeyPairs",
                  "lightsail:GetRelationalDatabaseSnapshots",
                  "lightsail:GetRelationalDatabases",
                  "logs:GetDeliveryDestinationPolicy",
                  "logs:GetLogAnomalyDetector",
                  "logs:GetScheduledQuery",
                  "logs:ListLogAnomalyDetectors",
                  "logs:ListScheduledQueries",
                  "lookoutequipment:DescribeDataset",
                  "lookoutequipment:DescribeInferenceScheduler",
                  "lookoutequipment:DescribeModel",
                  "lookoutequipment:ListInferenceSchedulers",
                  "lookoutequipment:ListModels",
                  "lookoutequipment:ListTagsForResource",
                  "lookoutvision:DescribeProject",
                  "macie2:GetAutomatedDiscoveryConfiguration",
                  "macie2:GetFindings",
                  "macie2:GetMacieSession",
                  "managedblockchain:GetAccessor",
                  "managedblockchain:GetMember",
                  "managedblockchain:GetNetwork",
                  "managedblockchain:GetNode",
                  "managedblockchain:GetProposal",
                  "managedblockchain:ListAccessors",
                  "managedblockchain:ListInvitations",
                  "managedblockchain:ListMembers",
                  "managedblockchain:ListNodes",
                  "managedblockchain:ListProposals",
                  "managedblockchain:ListTagsForResource",
                  "mediaconvert:GetJobTemplate",
                  "mediaconvert:GetPreset",
                  "mediaconvert:GetQueue",
                  "mediaconvert:ListJobTemplates",
                  "mediaconvert:ListPresets",
                  "mediaconvert:ListQueues",
                  "mediaconvert:ListTagsForResource",
                  "mediastore:ListTagsForResource",
                  "mediatailor:DescribeProgram",
                  "mediatailor:GetChannelSchedule",
                  "mediatailor:GetPlaybackConfiguration",
                  "mediatailor:GetPrefetchSchedule",
                  "mediatailor:ListChannels",
                  "mediatailor:ListLiveSources",
                  "mediatailor:ListPlaybackConfigurations",
                  "mediatailor:ListPrefetchSchedules",
                  "mediatailor:ListSourceLocations",
                  "mediatailor:ListTagsForResource",
                  "mediatailor:ListVodSources",
                  "medical-imaging:GetDatastore",
                  "medical-imaging:ListDatastores",
                  "medical-imaging:ListTagsForResource",
                  "memorydb:DescribeSnapshots",
                  "memorydb:ListTags",
                  "neptune-graph:GetGraph",
                  "neptune-graph:ListGraphSnapshots",
                  "neptune-graph:ListGraphs",
                  "neptune-graph:ListTagsForResource",
                  "network-firewall:DescribeProxy",
                  "network-firewall:DescribeProxyConfiguration",
                  "network-firewall:DescribeProxyRuleGroup",
                  "network-firewall:DescribeTLSInspectionConfiguration",
                  "network-firewall:DescribeVpcEndpointAssociation",
                  "network-firewall:ListProxies",
                  "network-firewall:ListProxyConfigurations",
                  "network-firewall:ListProxyRuleGroups",
                  "network-firewall:ListTLSInspectionConfigurations",
                  "network-firewall:ListVpcEndpointAssociations",
                  "networkmanager:GetCoreNetwork",
                  "networkmanager:ListCoreNetworks",
                  "networkmonitor:GetMonitor",
                  "networkmonitor:ListMonitors",
                  "oam:GetSink",
                  "oam:ListTagsForResource",
                  "omics:GetRun",
                  "omics:GetRunCache",
                  "omics:GetRunGroup",
                  "omics:GetSequenceStore",
                  "omics:GetWorkflow",
                  "omics:GetWorkflowVersion",
                  "omics:ListReadSets",
                  "omics:ListReferenceStores",
                  "omics:ListReferences",
                  "omics:ListRunCaches",
                  "omics:ListRunGroups",
                  "omics:ListRuns",
                  "omics:ListSequenceStores",
                  "omics:ListTagsForResource",
                  "omics:ListWorkflowVersions",
                  "omics:ListWorkflows",
                  "osis:GetPipeline",
                  "osis:ListPipelines",
                  "osis:ListTagsForResource",
                  "panorama:DescribeDevice",
                  "panorama:DescribePackage",
                  "panorama:ListDevices",
                  "panorama:ListPackages",
                  "payment-cryptography:GetKey",
                  "payment-cryptography:ListKeys",
                  "payment-cryptography:ListTagsForResource",
                  "personalize:DescribeBatchInferenceJob",
                  "personalize:DescribeBatchSegmentJob",
                  "personalize:DescribeCampaign",
                  "personalize:DescribeDataDeletionJob",
                  "personalize:DescribeDataset",
                  "personalize:DescribeDatasetExportJob",
                  "personalize:DescribeDatasetImportJob",
                  "personalize:DescribeEventTracker",
                  "personalize:DescribeFilter",
                  "personalize:DescribeMetricAttribution",
                  "personalize:DescribeRecommender",
                  "personalize:DescribeSchema",
                  "personalize:DescribeSolution",
                  "personalize:ListBatchInferenceJobs",
                  "personalize:ListBatchSegmentJobs",
                  "personalize:ListCampaigns",
                  "personalize:ListDataDeletionJobs",
                  "personalize:ListDatasetExportJobs",
                  "personalize:ListDatasetImportJobs",
                  "personalize:ListDatasets",
                  "personalize:ListEventTrackers",
                  "personalize:ListFilters",
                  "personalize:ListMetricAttributions",
                  "personalize:ListRecommenders",
                  "personalize:ListSchemas",
                  "personalize:ListSolutions",
                  "personalize:ListTagsForResource",
                  "pipes:DescribePipe",
                  "pipes:ListPipes",
                  "polly:GetLexicon",
                  "qbusiness:GetApplication",
                  "qbusiness:GetChatResponseConfiguration",
                  "qbusiness:GetDataSource",
                  "qbusiness:GetIndex",
                  "qbusiness:GetWebExperience",
                  "qbusiness:ListChatResponseConfigurations",
                  "qldb:DescribeJournalKinesisStream",
                  "qldb:ListJournalKinesisStreamsForLedger",
                  "qldb:ListTagsForResource",
                  "ram:GetPermission",
                  "rbin:GetRule",
                  "rbin:ListRules",
                  "rbin:ListTagsForResource",
                  "redshift-serverless:GetScheduledAction",
                  "redshift-serverless:ListEndpointAccess",
                  "redshift-serverless:ListScheduledActions",
                  "refactor-spaces:ListApplications",
                  "refactor-spaces:ListEnvironments",
                  "refactor-spaces:ListRoutes",
                  "refactor-spaces:ListServices",
                  "resiliencehub:DescribeApp",
                  "resiliencehub:DescribeAppAssessment",
                  "resiliencehub:ListAppAssessments",
                  "resiliencehub:ListApps",
                  "resiliencehub:ListRecommendationTemplates",
                  "resiliencehub:ListResiliencyPolicies",
                  "resiliencehub:ListTagsForResource",
                  "resource-groups:GetAccountSettings",
                  "resource-groups:GetGroupConfiguration",
                  "resource-groups:GetGroupQuery",
                  "resource-groups:GetTags",
                  "resource-groups:ListGroups",
                  "s3:GetIntelligentTieringConfiguration",
                  "s3:GetJobTagging",
                  "s3:GetStorageLensConfigurationTagging",
                  "s3tables:GetTable",
                  "s3tables:GetTableBucketEncryption",
                  "s3tables:GetTableBucketMetricsConfiguration",
                  "s3tables:ListTagsForResource",
                  "s3vectors:ListTagsForResource",
                  "scheduler:GetSchedule",
                ]
                "Effect"   = "Allow"
                "Resource" = "*"
                "Sid"      = "WizFullPolicy3"
              },
            ]
            "Version" = "2012-10-17"
          }
          "Roles" = [
            {
              "Ref" = "Role"
            },
          ]
        }
        "Type" = "AWS::IAM::ManagedPolicy"
      }
      "WizFullPolicy4" = {
        "Properties" = {
          "ManagedPolicyName" = {
            "Fn::Sub" = "WizFullPolicy4$${WizPolicyNameSuffix}"
          }
          "PolicyDocument" = {
            "Statement" = [
              {
                "Action" = [
                  "scheduler:ListSchedules",
                  "scheduler:ListTagsForResource",
                  "securitylake:GetDataLakeSources",
                  "securitylake:ListDataLakes",
                  "securitylake:ListSubscribers",
                  "securitylake:ListTagsForResource",
                  "serverlessrepo:GetApplication",
                  "servicecatalog:DescribePortfolio",
                  "servicecatalog:DescribePortfolioShares",
                  "servicecatalog:DescribeProductAsAdmin",
                  "servicecatalog:SearchProductsAsAdmin",
                  "servicediscovery:GetNamespace",
                  "servicediscovery:GetService",
                  "servicediscovery:ListNamespaces",
                  "servicediscovery:ListServices",
                  "servicediscovery:ListTagsForResource",
                  "ses:GetDedicatedIpPool",
                  "ses:GetIngressPoint",
                  "ses:GetRuleSet",
                  "signer:GetSigningProfile",
                  "signer:ListSigningProfiles",
                  "snowball:DescribeJob",
                  "sns:GetDataProtectionPolicy",
                  "sns:GetSubscriptionAttributes",
                  "ssm-incidents:GetReplicationSet",
                  "ssm-incidents:GetResourcePolicies",
                  "ssm-incidents:GetResponsePlan",
                  "ssm-incidents:ListReplicationSets",
                  "ssm-incidents:ListResponsePlans",
                  "ssm-incidents:ListTagsForResource",
                  "ssm:GetDocument",
                  "ssm:GetParameters",
                  "sso-directory:Describe*",
                  "sso-directory:ListMembersInGroup",
                  "states:ListTagsForResource",
                  "storagegateway:DescribeSMBFileShares",
                  "storagegateway:DescribeSMBSettings",
                  "sts:GetServiceBearerToken",
                  "swf:DescribeDomain",
                  "textract:GetAdapter",
                  "textract:GetAdapterVersion",
                  "textract:ListAdapterVersions",
                  "textract:ListAdapters",
                  "textract:ListTagsForResource",
                  "thinclient:GetEnvironment",
                  "thinclient:GetSoftwareSet",
                  "thinclient:ListEnvironments",
                  "thinclient:ListSoftwareSets",
                  "thinclient:ListTagsForResource",
                  "timestream-influxdb:GetDbCluster",
                  "timestream-influxdb:GetDbInstance",
                  "timestream-influxdb:GetDbParameterGroup",
                  "timestream-influxdb:ListDbClusters",
                  "timestream-influxdb:ListDbInstances",
                  "timestream-influxdb:ListDbParameterGroups",
                  "timestream-influxdb:ListTagsForResource",
                  "timestream:DescribeBatchLoadTask",
                  "timestream:DescribeEndpoints",
                  "timestream:DescribeScheduledQuery",
                  "timestream:ListBatchLoadTasks",
                  "timestream:ListDatabases",
                  "timestream:ListScheduledQueries",
                  "timestream:ListTables",
                  "timestream:ListTagsForResource",
                  "tnb:GetSolFunctionPackage",
                  "tnb:GetSolNetworkPackage",
                  "tnb:ListSolFunctionPackages",
                  "tnb:ListSolNetworkPackages",
                  "transcribe:GetCallAnalyticsJob",
                  "transcribe:GetMedicalScribeJob",
                  "transcribe:GetMedicalTranscriptionJob",
                  "transcribe:GetTranscriptionJob",
                  "transcribe:ListMedicalScribeJobs",
                  "verifiedpermissions:GetPolicyStore",
                  "verifiedpermissions:ListPolicyStores",
                  "voiceid:ListDomains",
                  "vpc-lattice:GetAccessLogSubscription",
                  "vpc-lattice:GetAuthPolicy",
                  "vpc-lattice:GetResourceConfiguration",
                  "vpc-lattice:GetResourceGateway",
                  "vpc-lattice:GetService",
                  "vpc-lattice:GetServiceNetwork",
                  "vpc-lattice:GetServiceNetworkResourceAssociation",
                  "vpc-lattice:GetServiceNetworkServiceAssociation",
                  "vpc-lattice:GetServiceNetworkVpcAssociation",
                  "vpc-lattice:GetTargetGroup",
                  "vpc-lattice:ListAccessLogSubscriptions",
                  "vpc-lattice:ListDomainVerifications",
                  "vpc-lattice:ListResourceConfigurations",
                  "vpc-lattice:ListResourceEndpointAssociations",
                  "vpc-lattice:ListResourceGateways",
                  "vpc-lattice:ListServiceNetworkResourceAssociations",
                  "vpc-lattice:ListServiceNetworkServiceAssociations",
                  "vpc-lattice:ListServiceNetworkVpcAssociations",
                  "vpc-lattice:ListServiceNetworks",
                  "vpc-lattice:ListServices",
                  "vpc-lattice:ListTagsForResource",
                  "vpc-lattice:ListTargetGroups",
                  "wafv2:GetIPSet",
                  "wafv2:GetRuleGroup",
                  "wellarchitected:GetLens",
                  "wellarchitected:GetProfile",
                  "wellarchitected:GetReviewTemplate",
                  "wellarchitected:GetWorkload",
                  "wellarchitected:ListLenses",
                  "wellarchitected:ListProfiles",
                  "wellarchitected:ListReviewTemplates",
                  "wellarchitected:ListWorkloads",
                  "workmail:GetDefaultRetentionPolicy",
                  "workmail:ListAccessControlRules",
                  "workmail:ListAvailabilityConfigurations",
                  "workmail:ListMailDomains",
                  "workmail:ListOrganizations",
                  "workmail:ListPersonalAccessTokens",
                  "workmail:ListTagsForResource",
                  "workspaces-web:GetBrowserSettings",
                  "workspaces-web:GetNetworkSettings",
                  "workspaces-web:GetPortal",
                  "workspaces-web:GetUserSettings",
                  "workspaces-web:ListBrowserSettings",
                  "workspaces-web:ListNetworkSettings",
                  "workspaces-web:ListPortals",
                  "workspaces-web:ListTagsForResource",
                  "workspaces-web:ListUserSettings",
                ]
                "Effect"   = "Allow"
                "Resource" = "*"
                "Sid"      = "WizFullPolicy4"
              },
            ]
            "Version" = "2012-10-17"
          }
          "Roles" = [
            {
              "Ref" = "Role"
            },
          ]
        }
        "Type" = "AWS::IAM::ManagedPolicy"
      }
      "WizLightsailScanningPolicy" = {
        "Condition" = "LightsailScanningEnabled"
        "Properties" = {
          "ManagedPolicyName" = {
            "Fn::Sub" = "WizLightsailScanningPolicy$${WizPolicyNameSuffix}"
          }
          "PolicyDocument" = {
            "Statement" = [
              {
                "Action" = "iam:CreateServiceLinkedRole"
                "Condition" = {
                  "StringLike" = {
                    "iam:AWSServiceName" = "lightsail.amazonaws.com"
                  }
                }
                "Effect" = "Allow"
                "Resource" = {
                  "Fn::Sub" = "arn:$${AWS::Partition}:iam::*:role/aws-service-role/lightsail.amazonaws.com/AWSServiceRoleForLightsail*"
                }
              },
              {
                "Action" = [
                  "iam:PutRolePolicy",
                ]
                "Effect" = "Allow"
                "Resource" = {
                  "Fn::Sub" = "arn:$${AWS::Partition}:iam::*:role/aws-service-role/lightsail.amazonaws.com/AWSServiceRoleForLightsail*"
                }
              },
              {
                "Action" = [
                  "lightsail:CreateDiskSnapshot",
                  "lightsail:TagResource",
                ]
                "Condition" = {
                  "StringEquals" = {
                    "aws:RequestTag/wiz" = "auto-gen-snapshot"
                  }
                }
                "Effect"   = "Allow"
                "Resource" = "*"
              },
              {
                "Action" = [
                  "lightsail:DeleteDiskSnapshot",
                  "lightsail:ExportSnapshot",
                ]
                "Condition" = {
                  "StringEquals" = {
                    "aws:ResourceTag/wiz" = "auto-gen-snapshot"
                  }
                }
                "Effect"   = "Allow"
                "Resource" = "*"
              },
              {
                "Action" = [
                  "lightsail:GetDiskSnapshot",
                  "lightsail:GetDiskSnapshots",
                  "lightsail:GetExportSnapshotRecords",
                ]
                "Effect"   = "Allow"
                "Resource" = "*"
              },
              {
                "Action" = [
                  "ec2:DeleteSnapshot",
                  "ec2:ModifySnapshotAttribute",
                ]
                "Condition" = {
                  "StringLike" = {
                    "ec2:ParentVolume" = {
                      "Fn::Sub" = "arn:$${AWS::Partition}:ec2:*:*:volume/vol-ffffffff"
                    }
                  }
                }
                "Effect"   = "Allow"
                "Resource" = "*"
              },
            ]
            "Version" = "2012-10-17"
          }
          "Roles" = [
            {
              "Ref" = "Role"
            },
          ]
        }
        "Type" = "AWS::IAM::ManagedPolicy"
      }
      "WizTerraformScanningPolicy" = {
        "Condition" = "TerraformBucketScanning"
        "Properties" = {
          "ManagedPolicyName" = {
            "Fn::Sub" = "WizTerraformScanningPolicy$${WizPolicyNameSuffix}"
          }
          "PolicyDocument" = {
            "Statement" = [
              {
                "Action" = [
                  "s3:GetBucketLocation",
                  "s3:GetObject",
                  "s3:GetObjectTagging",
                  "s3:ListBucket",
                ]
                "Effect" = "Allow"
                "Resource" = [
                  {
                    "Fn::Sub" = "arn:$${AWS::Partition}:s3:::*terraform*"
                  },
                  {
                    "Fn::Sub" = "arn:$${AWS::Partition}:s3:::*tfstate*"
                  },
                  {
                    "Fn::Sub" = "arn:$${AWS::Partition}:s3:::*tf?state*"
                  },
                  {
                    "Fn::Sub" = "arn:$${AWS::Partition}:s3:::*cloudtrail*"
                  },
                  {
                    "Fn::Sub" = "arn:$${AWS::Partition}:s3:::elasticbeanstalk-*"
                  },
                  {
                    "Fn::Sub" = "arn:$${AWS::Partition}:s3:::amplify-*-deployment/*"
                  },
                ]
                "Sid" = "WizTerraformBucketAccess"
              },
            ]
            "Version" = "2012-10-17"
          }
          "Roles" = [
            {
              "Ref" = "Role"
            },
          ]
        }
        "Type" = "AWS::IAM::ManagedPolicy"
      }
    }
  }
}
