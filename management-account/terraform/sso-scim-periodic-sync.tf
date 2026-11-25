# Resources for the periodic GitHub team -> AWS IAM Identity Center sync (v2).
#
# The GitHub App private key (JSON) secret is declared in secrets-manager.tf.
# This file holds the audit-log cursor parameter; the module call (pinned to a
# tagged release of moj-terraform-github-periodic-sync) is added once published.

# Audit-log cursor: the single piece of persistent state for the poller. The
# Lambda owns the value; Terraform seeds a placeholder and ignores later changes
# (the poller treats an unparseable value as "first run").
resource "aws_ssm_parameter" "github_periodic_sync_audit_cursor" {
  name        = "/moj-github-periodic-sync/audit_cursor"
  description = "High-water mark of the last processed GitHub audit-log event for the periodic sync."
  type        = "String"
  value       = "uninitialised"

  lifecycle {
    ignore_changes = [value]
  }
}

# The poller: self-building Lambda + EventBridge schedule + least-privilege IAM.
# Shadow mode (not_dry_run = false) logs the diff it would apply without writing;
# flip to true only after CloudWatch confirms a clean plan. v1_lambda_name
# defaults to the v1 Lambda inside the module, seeding the first-run window.
module "github_periodic_sync" {
  # tflint-ignore: terraform_module_pinned_source
  source = "github.com/ministryofjustice/moj-terraform-github-periodic-sync?ref=51c329beb7b8f3639b8ce026be3f2577b17cab1b" # v0.1.2

  github_organisation   = local.sso.github_organisation
  github_app_secret_arn = aws_secretsmanager_secret.github_periodic_sync_private_key.arn
  cursor_parameter_name = aws_ssm_parameter.github_periodic_sync_audit_cursor.name

  sso_aws_region        = local.sso.region
  sso_identity_store_id = local.sso_admin_identity_store_id
  sso_email_suffix      = local.sso.email_suffix

  not_dry_run = false
}
