variable "external-id" {
  type        = string
  description = "Connector External ID"
  validation {
    condition     = can(regex("\\S{8}-\\S{4}-\\S{4}-\\S{4}-\\S{12}", var.external-id))
    error_message = "The external_id must match the pattern XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX (UUID format)."
  }
}

variable "rolename" {
  type        = string
  default     = "WizAccess-Role"
  description = "Enter the IAM role name that will be created in your AWS account, the default is WizAccess-Role"
}

variable "remote-arn" {
  type        = string
  default     = ""
  description = "Enter the AWS Trust Policy Role ARN for your Wiz data center. You can retrieve it from User Settings, Tenant in the Wiz portal"
}

variable "permission_boundary_arn" {
  type        = string
  default     = null
  description = "Optional - ARN of the policy that is used to set the permissions boundary for the role."
}

variable "role_path" {
  type        = string
  default     = "/"
  description = "The path for the IAM role. Useful for organizing roles under a specific path (e.g., /governance/)."
}

variable "lightsail-scanning" {
  type        = bool
  default     = false
  description = "Enable Lightsail scanning"
}

variable "data-scanning" {
  type        = bool
  default     = false
  description = "Enable DSPM data scanning"
}

variable "eks-scanning" {
  type        = bool
  default     = false
  description = "Enable EKS scanning"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "iam_policy_suffix" {
  description = "(Optional) suffix for the policy name"
  type        = string
  default     = ""
}

variable "wiz-defend-s3-kms-policy" {
  description = "(Optional) Enable Wiz Defend S3 KMS policy"
  type        = bool
  default     = true
}

variable "wiz-defend-rds-policy" {
  description = "(Optional) Enable Wiz Defend RDS policy"
  type        = bool
  default     = true
}

variable "wiz-defend-awslogs-policy" {
  description = "(Optional) Enable Wiz Defend AWS Logs policy"
  type        = bool
  default     = true
}

variable "terraform-bucket-scanning" {
  type        = bool
  default     = true
  description = "Enable Terraform Bucket scanning"
}

variable "cloud-cost-scanning" {
  type        = bool
  default     = true
  description = "Enable Cloud Cost scanning"
}

variable "s3-inventory-scanning" {
  type        = bool
  default     = false
  description = "Enable S3 Inventory Scanning. Disabled by default."
}

locals {
  wiz_version_last_updated = jsondecode(file("${path.module}/timestamp.json"))
}
