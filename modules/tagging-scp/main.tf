locals {
  tag_names = [for tag in var.tags_to_enforce : tag.tag]
}

# Policies
resource "aws_organizations_policy" "default" {
  name        = "Enforce ${join(", ", local.tag_names)} tag"
  description = "Enforces the presence of mandatory ${join(", ", local.tag_names)} tag"
  type        = "SERVICE_CONTROL_POLICY"
  tags = {
    business-unit = "Platforms"
    component     = "SERVICE_CONTROL_POLICY"
    source-code   = join("", [var.github_repository, "/terraform/organizations-service-control-policies.tf"])
  }

  content = data.aws_iam_policy_document.default.json
}

# Policy Documents
data "aws_iam_policy_document" "default" {
  dynamic "statement" {
    for_each = var.tags_to_enforce

    content {
      sid       = "DenyMissing${join("", [for part in split("-", statement.value.tag) : title(part)])}"
      effect    = "Deny"
      actions   = var.iam_actions
      resources = var.resources

      condition {
        test     = "Null"
        variable = "aws:RequestTag/${statement.value.tag}"
        values   = ["true"]
      }
    }
  }

  dynamic "statement" {
    for_each   = {
      for item in var.tags_to_enforce :
      item.tag => item.valid_values
      if length(item.valid_values) > 0
    }

    content {
      sid       = "DenyInvalid${join("", [for part in split("-", statement.key) : title(part)])}"
      effect    = "Deny"
      actions   = var.iam_actions
      resources = var.resources

      condition {
        test     = "StringNotEquals"
        variable = "aws:RequestTag/${statement.key}"
        values = statement.value
      }
    }
  }
}

# Policy Attachments
resource "aws_organizations_policy_attachment" "default" {
  for_each = toset(var.organisational_unit_ids)

  policy_id = aws_organizations_policy.default.id
  target_id = each.value
}