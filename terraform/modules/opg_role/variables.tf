variable "user_arns" {
  type    = list(string)
  default = []
}

variable "name" {}

variable "base_policy_arn" {
  default = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

variable "custom_policy_json" {
  default = ""
}
