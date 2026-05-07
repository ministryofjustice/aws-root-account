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
      sid       = "DenyMissing${statement.value.tag}"
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
      for tag, valid_values in var.tags_to_enforce :
      tag => {
        tag          = tag
        valid_values = valid_values
      }
      if length(valid_values) > 0
    }

    content {
      sid       = "DenyInvalid${statement.value.tag}"
      effect    = "Deny"
      actions   = var.iam_actions
      resources = var.resources

      condition {
        test     = "StringNotEquals"
        variable = "aws:RequestTag/${statement.value.tag}"
        values = statement.value.valid_values
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