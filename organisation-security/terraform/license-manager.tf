# Oracle licensing

# Oracle RDS licensing
# Note automated discovery for these exist in AWS but cannot be done through terraform and must be done manually in the console
# https://docs.aws.amazon.com/license-manager/latest/userguide/automated-discovery.html
module "oracle_rds_license_configurations" {
  source = "../../modules/license-configuration"
  for_each = {
    "OracleDbSELicenseConfigurationRDS"   = { description = "Oracle Database Standard Edition (Amazon RDS)" },
    "OracleDbSE1LicenseConfigurationRDS"  = { description = "Oracle Database Standard Edition One (Amazon RDS)" },
    "OracleDbSE2LicenseConfigurationRDS"  = { description = "Oracle Database Standard Edition Two (Amazon RDS)" },
    "OracleDbEELicenseConfigurationRDS"   = { description = "Oracle Database Enterprise Edition (Amazon RDS)" },
    "OracleDbADGLicenseConfigurationRDS"  = { description = "Oracle Database Active Data Guard (Amazon RDS)" },
    "OracleDbLSLicenseConfigurationRDS"   = { description = "Oracle Database Label Security (Amazon RDS)" },
    "OracleDbOLAPLicenseConfigurationRDS" = { description = "Oracle Database Oracle On-Line Analytical Processing (OLAP) (Amazon RDS)" },
    "OracleDbDPLicenseConfigurationRDS"   = { description = "Oracle Database Diagnostic Pack for SQLT (Amazon RDS)" },
    "OracleDbTPLicenseConfigurationRDS"   = { description = "Oracle Database Tuning Pack for SQLT (Amazon RDS)" }
  }
  name                     = each.key
  description              = each.value.description
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
  principal                = local.organizations_organization.arn
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

# Upload the YAML file to the existing S3 bucket
resource "aws_s3_object" "oracle_db_lts_orchestrate_upload" {
  bucket = "license-manager-artifact-bucket" # Existing S3 bucket name
  key    = "OracleDbLTS-Orchestrate.yaml"
  source = filemd5("${path.module}/cloudformation/OracleDbLTS-Orchestrate.yaml")
  acl    = "private"
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
    Schedule                 = "cron(15 0 ? * MON *)"
  }
  template_url = "https://${aws_s3_object.oracle_db_lts_orchestrate.bucket}.s3.eu-west-2.amazonaws.com/${aws_s3_object.oracle_db_lts_orchestrate.key}"

  depends_on = [
    module.oracle_ec2_license_configurations
  ]
  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
  }
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
