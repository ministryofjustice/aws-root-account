# Compares Wiz's published member template with the committed copy. A
# difference is a check warning, not a plan failure. The data source sits outside
# the check block: a scoped data source is always deferred to apply, which would
# make every plan report changes.

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = ">= 3.4, < 4.0"
    }
  }
}

variable "url" {
  type        = string
  description = "Vendor URL of the published member template."
}

variable "committed_sha256" {
  type        = string
  description = "SHA-256 of the committed vendor template."
}

variable "committed_version" {
  type        = string
  description = "WizVersionLastUpdated of the committed vendor template."
}

data "http" "wiz_upstream" {
  url = var.url
}

locals {
  upstream_version = try(jsondecode(data.http.wiz_upstream.response_body).Parameters.WizVersionLastUpdated.Default, "unreadable")
}

check "wiz_template_current" {
  assert {
    condition     = sha256(data.http.wiz_upstream.response_body) == var.committed_sha256
    error_message = "Wiz has published member template ${local.upstream_version}; it differs from the committed copy (${var.committed_version}). Review the upstream changes, then update wiz-aws-standard.json, its checksum and the HCL template."
  }
}
