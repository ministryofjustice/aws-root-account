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
