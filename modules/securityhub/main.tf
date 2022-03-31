# Get current region
data "aws_region" "current" {}

######################
# Self-configuration #
######################

# Enable Security Hub
resource "aws_securityhub_account" "default" {}

# Subscribe to AWS Foundational Security Best Practices v1.0.0
resource "aws_securityhub_standards_subscription" "default_aws_foundational_security_best_practices" {
  depends_on    = [aws_securityhub_account.default]
  standards_arn = "arn:aws:securityhub:${data.aws_region.current.name}::standards/aws-foundational-security-best-practices/v/1.0.0"
}

# Subscribe to CIS AWS Foundations v1.2.0
resource "aws_securityhub_standards_subscription" "default_cis_aws_foundations" {
  depends_on    = [aws_securityhub_account.default]
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
}

# Subscribe to PCI DSS v3.2.1
resource "aws_securityhub_standards_subscription" "default_pci_dss" {
  depends_on    = [aws_securityhub_account.default]
  standards_arn = "arn:aws:securityhub:${data.aws_region.current.name}::standards/pci-dss/v/3.2.1"
}

###########################
# Management account only #
###########################

# Set the delegated administrator
resource "aws_securityhub_organization_admin_account" "default" {
  for_each         = var.is_delegated_administrator == false && var.admin_account != null ? toset(["delegated_administrator"]) : []
  admin_account_id = var.admin_account
}

########################################
# Delegated administrator account only #
########################################

# Configure organisational settings
resource "aws_securityhub_organization_configuration" "default" {
  for_each    = var.is_delegated_administrator ? toset(["delegated_administrator"]) : []
  auto_enable = false
}

# Add members from the organisation
resource "aws_securityhub_member" "default" {
  depends_on = [aws_securityhub_account.default]
  for_each   = var.is_delegated_administrator ? var.enrolled_accounts : {}

  account_id = each.value
  email      = "placeholder-to-avoid-terraform-drift@example.com"
  invite     = false

  lifecycle {
    ignore_changes = [
      email,
      invite
    ]
  }
}

# Create an finding aggregator
resource "aws_securityhub_finding_aggregator" "default" {
  depends_on = [aws_securityhub_account.default]
  for_each   = var.is_delegated_administrator && var.aggregation_region ? toset(["aggregator"]) : []

  linking_mode = "ALL_REGIONS"
}
