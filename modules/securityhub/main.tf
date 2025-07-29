# Get current region
data "aws_region" "current" {}

# Get current account
data "aws_caller_identity" "current" {}

###############################
# Self-configuration: general #
###############################

# Enable Security Hub
resource "aws_securityhub_account" "default" {
  # Consolidated Control Findings has been enabled manually, as no Terraform support currently exists for enabling it centrally.
  control_finding_generator = "SECURITY_CONTROL"
  lifecycle {
    ignore_changes = [
      # When importing this can't be changed without destroying the resource
      enable_default_standards,
    ]
  }
}

# Subscribe to AWS Foundational Security Best Practices v1.0.0
resource "aws_securityhub_standards_subscription" "default_aws_foundational_security_best_practices" {
  depends_on    = [aws_securityhub_account.default]
  standards_arn = "arn:aws:securityhub:${data.aws_region.current.region}::standards/aws-foundational-security-best-practices/v/1.0.0"
}

# Subscribe to CIS AWS Foundations v1.2.0
resource "aws_securityhub_standards_subscription" "default_cis_aws_foundations" {
  depends_on    = [aws_securityhub_account.default]
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
}

# Subscribe to CIS AWS Foundations v1.4.0
resource "aws_securityhub_standards_subscription" "default_cis_aws_foundations_1_4_0" {
  depends_on    = [aws_securityhub_account.default]
  standards_arn = "arn:aws:securityhub:${data.aws_region.current.region}::standards/cis-aws-foundations-benchmark/v/1.4.0"
}

# Subscribe to PCI DSS v3.2.1
resource "aws_securityhub_standards_subscription" "default_pci_dss" {
  depends_on    = [aws_securityhub_account.default]
  standards_arn = "arn:aws:securityhub:${data.aws_region.current.region}::standards/pci-dss/v/3.2.1"
}

############################################
# Self-configuration: turning off controls #
############################################

# AWS Foundational Security Best Practices v1.0.0
resource "aws_securityhub_standards_control" "default_aws_foundational_security_best_practices_hardware_mfa" {
  standards_control_arn = "arn:aws:securityhub:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:control/aws-foundational-security-best-practices/v/1.0.0/IAM.6"
  control_status        = "DISABLED"
  disabled_reason       = "Due to the risk of losing hardware, we store passwords in a closed box using different methods. Further, root access to an account is restricted by an SCP."
  depends_on            = [aws_securityhub_standards_subscription.default_aws_foundational_security_best_practices]
}

# CIS AWS Foundations v1.2.0
resource "aws_securityhub_standards_control" "default_cis_aws_foundations_hardware_mfa" {
  standards_control_arn = "arn:aws:securityhub:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/1.14"
  control_status        = "DISABLED"
  disabled_reason       = "Due to the risk of losing hardware, we store passwords in a closed box using different methods. Further, root access to an account is restricted by an SCP."
  depends_on            = [aws_securityhub_standards_subscription.default_cis_aws_foundations]
}

# PCI DSS v3.2.1
resource "aws_securityhub_standards_control" "default_pci_dss_hardware_mfa" {
  standards_control_arn = "arn:aws:securityhub:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:control/pci-dss/v/3.2.1/PCI.IAM.4"
  control_status        = "DISABLED"
  disabled_reason       = "Due to the risk of losing hardware, we store passwords in a closed box using different methods. Further, root access to an account is restricted by an SCP."
  depends_on            = [aws_securityhub_standards_subscription.default_pci_dss]
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
  auto_enable = true
}

# Add members from the organisation
# This is now down automatically when accounts are created
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
