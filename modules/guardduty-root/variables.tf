variable "root_tags" {
  description = "Tags to apply to resources created in the root account, if applicable"
  type        = map(any)
  default     = {}
}

variable "administrator_tags" {
  description = "Tags to apply to resources created in the delegated administrator account, if applicable"
  type        = map(any)
  default     = {}
}
