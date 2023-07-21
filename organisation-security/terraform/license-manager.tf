# Windows licensing
resource "aws_licensemanager_license_configuration" "windows_server_datacenter_2019" {
  name                     = "Windows Server Datacenter 2019 (EC2 and on-premises)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

# Oracle licensing
resource "aws_licensemanager_license_configuration" "oracle_tuning_pack_for_sqlt" {
  name                     = "Oracle Database Tuning Pack for SQLT (Amazon RDS)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

resource "aws_licensemanager_license_configuration" "oracle_diagnostic_pack_sqlt" {
  name                     = "Oracle Database Diagnostic Pack for SQLT (Amazon RDS)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

resource "aws_licensemanager_license_configuration" "oracle_olap" {
  name                     = "Oracle Database Oracle On-Line Analytical Processing (OLAP) (Amazon RDS)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

resource "aws_licensemanager_license_configuration" "oracle_label_security" {
  name                     = "Oracle Database Label Security (Amazon RDS)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

resource "aws_licensemanager_license_configuration" "oracle_adg" {
  name                     = "Oracle Database Active Data Guard (Amazon RDS)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

resource "aws_licensemanager_license_configuration" "oracle_se" {
  name                     = "Oracle Database Standard Edition (Amazon RDS)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

resource "aws_licensemanager_license_configuration" "oracle_se1" {
  name                     = "Oracle Database Standard Edition One (Amazon RDS)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

resource "aws_licensemanager_license_configuration" "oracle_se2" {
  name                     = "Oracle Database Standard Edition Two (Amazon RDS)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

resource "aws_licensemanager_license_configuration" "oracle_ee" {
  name                     = "Oracle Database Enterprise Edition (Amazon RDS)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

resource "aws_licensemanager_license_configuration" "oracle_ec2_licensemanager_configurations" {
  for_each = {
    "OracleDbEELicenseConfiguration"  = { description = "Oracle EC2 DB Enterprise Edition" },
    "OracleDbSE2LicenseConfiguration" = { description = "Oracle EC2 DB Standard Edition 2" },
    "OracleDbPELicenseConfiguration"  = { description = "Oracle EC2 DB Personal Edition" },
    "OracleDbXELicenseConfiguration"  = { description = "Oracle EC2 DB Express Edition" }
  }
  name                     = each.key
  description              = each.value.description
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

# Cloudformation stack for Oracle Database auto detection
resource "aws_cloudformation_stack" "oracleblts" {
  name         = "OracleDbLTS"
  capabilities = ["CAPABILITY_NAMED_IAM"]
  parameters = {
    IsDelegatedAdministrator = true
    ArtifactsS3Bucket        = "license-manager-artifact-bucket"
    AdministratorAccountId   = data.aws_caller_identity.current.id
    OrganizationId           = data.aws_organizations_organization.default.id
    InstanceIAMRoleName      = "AmazonSSMRoleForInstancesQuickSetup" # I've made this up, will question the need for this
    TargetOUs                = local.ou_example
    TargetRegions            = "eu-west-2"
    TargetKey                = "tag:OracleDbLTS-ManagedInstance"
    TargetValues             = true
    MaxConcurrency           = 4
    MaxErrors                = 4
  }

  template_body = file("${path.module}/cloudformation/OracleDbLTS-Orchestrate.yaml")
}

# TODO get some values below from stack above or make dependant on stack
resource "aws_ssm_association" "license_manager" {
  name             = "OracleDbLTS-Orchestrate"
  association_name = "OracleDbLicenseTrackingSolutionAssociation"

  # schedule_expression = "0 1 * * *"
  max_concurrency = 4
  max_errors      = 4
  parameters = {
    AutomationAssumeRole = "arn:aws:iam::${data.aws_caller_identity.current.id}:role/OracleDbLTS-SystemsManagerAutomationAdministrationRole"
    DeploymentTargets    = local.ou_example
    TargetRegions        = "eu-west-2"
  }
}
