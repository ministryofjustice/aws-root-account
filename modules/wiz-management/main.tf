terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0, < 7.0"
    }
  }
}

variable "wiz_management_account_id" {
  type        = string
  description = "Expected management-account ID; guards against deploying through the wrong provider."
  validation {
    condition     = can(regex("^[0-9]{12}$", var.wiz_management_account_id))
    error_message = "Supply the 12-digit AWS management-account ID."
  }
}

variable "wiz_external_id" {
  type        = string
  sensitive   = true
  description = "External ID supplied by the Wiz AWS connector."
  validation {
    condition     = can(regex("^\\S{8}-\\S{4}-\\S{4}-\\S{4}-\\S{12}$", var.wiz_external_id))
    error_message = "Use the UUID-shaped external ID supplied by Wiz."
  }
}

variable "wiz_trust_role_arn" {
  type        = string
  description = "Wiz's tenant/data-centre trust role ARN, not the MoJ deployment role."
  validation {
    condition     = can(regex("^arn:aws(-us-gov|-cn)?:iam::[0-9]{12}:role/.+$", var.wiz_trust_role_arn))
    error_message = "Supply Wiz's trust policy role ARN from the tenant settings."
  }
}

variable "wiz_role_name" {
  type        = string
  default     = "WizAccess-Role"
  description = "Name of the role Wiz assumes in the management account."
}

variable "wiz_role_path" {
  type        = string
  default     = "/"
  description = "IAM role path; retain / when enabling the vendor EKS policy."
  validation {
    condition     = can(regex("^(/|/[!-~]+/)$", var.wiz_role_path))
    error_message = "Role path must be / or begin and end with / without spaces."
  }
}

variable "wiz_policy_name_suffix" {
  type        = string
  default     = ""
  description = "Optional suffix appended to each Wiz policy name."
}

variable "wiz_permission_boundary_policy_name" {
  type        = string
  default     = ""
  description = "Optional existing IAM permissions-boundary policy name (including its path if applicable)."
}

variable "wiz_tags" {
  type    = map(string)
  default = {}
}

variable "wiz_features" {
  description = "Optional feature switches. Defaults match Wiz's 2026-10-21 module."
  type = object({
    cloud_cost_scanning       = optional(bool, true)
    data_scanning             = optional(bool, false)
    eks_scanning              = optional(bool, false)
    lightsail_scanning        = optional(bool, false)
    rds_logs_scanning         = optional(bool, true)
    s3_aws_logs_scanning      = optional(bool, true)
    s3_inventory_scanning     = optional(bool, false)
    s3_kms_decrypt            = optional(bool, true)
    terraform_bucket_scanning = optional(bool, true)
  })
  default = {}
}

data "aws_partition" "wiz_management" {}

data "aws_caller_identity" "wiz_management" {
  lifecycle {
    postcondition {
      condition     = self.account_id == var.wiz_management_account_id
      error_message = "AWS provider is authenticated to a different account than wiz_management_account_id."
    }
    postcondition {
      condition     = !var.wiz_features.eks_scanning || var.wiz_role_path == "/"
      error_message = "The vendor EKS policy assumes the default role path /. Retain / when eks_scanning is enabled."
    }
  }
}

module "vendor" {
  source = "https://wizio-public.s3.amazonaws.com/deployment-v3/aws/terraform/2796/wiz-aws-native-terraform-terraform-module.zip"

  external-id               = var.wiz_external_id
  remote-arn                = var.wiz_trust_role_arn
  rolename                  = var.wiz_role_name
  role_path                 = var.wiz_role_path
  iam_policy_suffix         = var.wiz_policy_name_suffix
  permission_boundary_arn   = var.wiz_permission_boundary_policy_name == "" ? null : "arn:${data.aws_partition.wiz_management.partition}:iam::${data.aws_caller_identity.wiz_management.account_id}:policy/${var.wiz_permission_boundary_policy_name}"
  tags                      = merge(var.wiz_tags, { managed_by = "Terraform" })
  cloud-cost-scanning       = var.wiz_features.cloud_cost_scanning
  data-scanning             = var.wiz_features.data_scanning
  eks-scanning              = var.wiz_features.eks_scanning
  lightsail-scanning        = var.wiz_features.lightsail_scanning
  wiz-defend-rds-policy     = var.wiz_features.rds_logs_scanning
  wiz-defend-awslogs-policy = var.wiz_features.s3_aws_logs_scanning
  s3-inventory-scanning     = var.wiz_features.s3_inventory_scanning
  wiz-defend-s3-kms-policy  = var.wiz_features.s3_kms_decrypt
  terraform-bucket-scanning = var.wiz_features.terraform_bucket_scanning

  depends_on = [data.aws_caller_identity.wiz_management]
}

output "wiz_management_role_arn" {
  value       = module.vendor.role_arn
  description = "Role ARN to configure for management-account access in Wiz."
}
