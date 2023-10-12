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

# Oracle DB on EC2 licensing automation
# https://aws.amazon.com/blogs/mt/centrally-track-oracle-database-licenses-in-aws-organizations-using-aws-license-manager-and-aws-systems-manager/

module "oracle_ec2_license_configurations" {
  source = "../../modules/license-configuration"
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
  principal                = local.ou_modernisation_platform_member_arn
}

# Cloudformation stack for Oracle Database auto detection
resource "aws_cloudformation_stack" "oracleblts" {
  name         = "OracleDbLTS"
  capabilities = ["CAPABILITY_NAMED_IAM"]
  parameters = {
    IsDelegatedAdministrator = true
    ArtifactsS3Bucket        = "license-manager-artifact-bucket"
    AdministratorAccountId   = data.aws_caller_identity.current.id
    OrganizationId           = local.organizations_organization.id
    TargetOUs                = local.ou_modernisation_platform_member_id
    TargetRegions            = "eu-west-2"
    TargetKey                = "tag:OracleDbLTS-ManagedInstance"
    TargetValues             = true
    MaxConcurrency           = 4
    MaxErrors                = 4
  }
  template_body = file("${path.module}/cloudformation/OracleDbLTS-Orchestrate.yaml")

  depends_on = [
    module.oracle_ec2_license_configurations
  ]
}

# Trigger automation
resource "aws_ssm_association" "license_manager" {
  name             = "OracleDbLTS-Orchestrate"
  association_name = "OracleDbLicenseTrackingSolutionAssociation"

  schedule_expression = "cron(15 0 ? * MON *)"
  # schedule_expression = "cron(25 10 ? * * *)"
  max_concurrency                  = 4
  max_errors                       = 4
  automation_target_parameter_name = "InstanceId"
  parameters = {
    AutomationAssumeRole = "arn:aws:iam::${data.aws_caller_identity.current.id}:role/OracleDbLTS-SystemsManagerAutomationAdministrationRole"
    DeploymentTargets    = join(",", local.license_mamager_ous)
    # DeploymentTargets    = join(",", local.modernisation_platform_member_ous) #Key DeploymentTargets must have length less than or equal to 512
    TargetRegions = "eu-west-2"
  }

  depends_on = [
    aws_cloudformation_stack.oracleblts
  ]
}

# Athena resources
resource "aws_athena_database" "ssm_resource_sync" {
  name   = "ssm_resource_sync"
  bucket = module.ssm_resource_sync_s3_bucket.bucket_name
}

# Glue crawler to update Athena Table
# Role for crawler
resource "aws_iam_role" "ssm_glue_crawler" {
  name               = "ssm-glue-crawler"
  assume_role_policy = data.aws_iam_policy_document.ssm_glue_crawler_assume.json
}

data "aws_iam_policy_document" "ssm_glue_crawler_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "ssm_glue_crawler" {
  name   = "SSMGlueCrawler"
  policy = data.aws_iam_policy_document.ssm_glue_crawler.json
}

data "aws_iam_policy_document" "ssm_glue_crawler" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = ["arn:aws:s3:::${module.ssm_resource_sync_s3_bucket.bucket_name}*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt"
    ]
    resources = [aws_kms_key.ssm_resource_sync.arn]
  }
}

resource "aws_iam_role_policy_attachment" "ssm_glue_crawler" {
  role       = aws_iam_role.ssm_glue_crawler.name
  policy_arn = aws_iam_policy.ssm_glue_crawler.arn
}

resource "aws_iam_role_policy_attachment" "ssm_glue_servicec" {
  role       = aws_iam_role.ssm_glue_crawler.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

# Glue Crawler
resource "aws_glue_crawler" "ssm_resource_sync" {
  database_name = aws_athena_database.ssm_resource_sync.name
  name          = "ssm_resource_sync"
  role          = aws_iam_role.ssm_glue_crawler.arn
  schedule      = "cron(15 1 ? * MON *)"

  s3_target {
    path = "s3://${module.ssm_resource_sync_s3_bucket.bucket_name}"
  }
}
