module "opg_breakglass" {
  source = "../../modules/sso-admin-permission-sets"
  name = "opg-breakglass"
  description = "Breakglass policy with full access to all services"
  instance_arn = local.sso_admin_instance_arn
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

module "opg_viewer" {
  source = "../../modules/sso-admin-permission-sets"
  name = "opg-viewer"
  description = "View only policy with explicit deny to storage and database services"
  instance_arn = local.sso_admin_instance_arn
  managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  inline_policy = data.aws_iam_policy_document.opg_viewer_deny.json
}

data "aws_iam_policy_document" "opg_viewer_deny" {
  policy_id = "opg-viewer-deny"
  statement {
    sid    = "ForbidStorageAccess"
    effect = "Deny"

    actions = [
      "s3:*",
      "elasticfilesystem:*",
      "fsx:*",
      "glacier:*",
      "storagegateway:*",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "ForbidDatabaseAccess"
    effect = "Deny"

    actions = [
      "rds:*",
      "dynamodb:*",
      "elasticache:*",
      "redshift:*",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "DenyPiiLogGroups"
    effect = "Deny"

    actions = [
      "logs:DescribeLogStreams",
      "logs:GetLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:log-group:/ecs/pii*",
      ]
  }
}

module "opg_billing" {
  source = "../../modules/sso-admin-permission-sets"
  name = "opg-billing"
  description = "Billing policy with permission to cost explorer and billing services"
  instance_arn = local.sso_admin_instance_arn
  managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  inline_policy = data.aws_iam_policy_document.opg_billing_deny.json
}

data "aws_iam_policy_document" "opg_billing_deny" {
  policy_id = "opg-billing-deny"
  statement {
    sid    = "AllowCostExplorerGet"
    effect = "Allow"
    actions = [
      "ce:get*"
    ]
    resources = ["*"]
  }
}

module "opg_modernising_lpa_development_operator" {
  source = "../../modules/sso-admin-permission-sets"
  name = "opg-modernising-lpa-development-operator"
  description = "Modernising LPA development operator policy with full access to all services"
  instance_arn = local.sso_admin_instance_arn
  managed_policy_arns = ["arn:aws:iam::aws:policy/breakglass"]
}

module "opg_modernising_lpa_preproduction_operator" {
  source = "../../modules/sso-admin-permission-sets"
  name = "opg-modernising-lpa-preproduction-operator"
  description = "Modernising LPA preproduction operator policy with full access to all services"
  instance_arn = local.sso_admin_instance_arn
  managed_policy_arns = ["arn:aws:iam::aws:policy/breakglass"]
}

module "opg_modernising_lpa_production_operator" {
  source = "../../modules/sso-admin-permission-sets"
  name = "opg-modernising-lpa-production-operator"
  description = "Modernising LPA production operator policy explicit deny to storage and database services and full access to all other services"
  instance_arn = local.sso_admin_instance_arn
  managed_policy_arns = ["arn:aws:iam::aws:policy/breakglass"]
  inline_policy = data.aws_iam_policy_document.opg_viewer_deny.json
}
