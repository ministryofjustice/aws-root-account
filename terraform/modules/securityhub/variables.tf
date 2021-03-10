variable "enrolled_into_securityhub" {
  description = "Map of key => values where key is the account name and the value is the account ID"
  type        = map(any)
}
