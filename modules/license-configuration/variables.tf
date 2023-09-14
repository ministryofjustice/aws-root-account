variable "name" {
  type    = string
  default = null
}

variable "principal" {
  type        = string
  default     = null
  description = "Principal to RAM share with"
}

variable "description" {
  type    = string
  default = null
}

variable "license_count" {
  type    = number
  default = 0
}

variable "license_count_hard_limit" {
  type    = bool
  default = false
}

variable "license_counting_type" {
  type    = string
  default = "vCPU"
}

