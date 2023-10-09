variable "tags" {
  description = "Tags to apply to resources"
  default     = {}
}

variable "repository_with_owner" {
  description = "GitHub repository with owner (e.g. ministryofjustice/aws-root-account) for access"
}

variable "repository_branch" {
  description = "GitHub repository branch name for access (e.g. main)"
}

variable "organisation_security_account_id" {
  description = "Organisation Security account ID"
  default     = ""
}
