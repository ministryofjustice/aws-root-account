variable "bucket_name" {
  type = string
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "bucket_acl" {
  type    = string
  default = "private"
}

variable "additional_tags" {
  type    = map(any)
  default = {}
}
