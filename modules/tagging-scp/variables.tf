variable "iam_actions" {
  type    = list(string)
  default = []
}

variable "resources" {
  type    = list(string)
  default = ["*"]
}

variable "enforce_value" {
  type    = bool
  default = false
}

variable "tags_to_enforce" {
  type = list(object({
    tag                 = string
    valid_values        = list(string)
  }))
  default = []
}

variable "organisational_unit_ids" {
  type    = list(string)
  default = []
}

variable "github_repository" {
  type    = string
  default = "github.com/ministryofjustice/aws-root-account/blob/main"
}
