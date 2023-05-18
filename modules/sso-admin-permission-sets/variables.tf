variable "name" {
  description = "The name of the permission set."
  type        = string
  validation {
    condition     = length(var.name) < 32
    error_message = "Error: expected length of name to be in the range (1 - 32)."
  }
}

variable "description" {
  description = "The description of the permission set."
  type        = string
}

variable "instance_arn" {
  description = "The ARN of the SSO instance under which the operation will be executed."
  type        = string
}

variable "session_duration" {
  description = "The length of time that the application user sessions are valid in the ISO-8601 standard."
  type        = string
  default     = "PT2H"
}

variable "managed_policy_arns" {
  description = "A list of managed policy ARNs to attach to the permission set."
  type        = list(string)
}

variable "inline_policy" {
  description = "The IAM inline policy json to attach to the permission set."
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to assign to the permission set."
  type        = map(string)
  default     = {}
}
