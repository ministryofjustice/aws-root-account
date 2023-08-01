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

# Create license configurations
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
    # TargetOUs                = local.ou_modernisation_platform_member_id
    TargetRegions            = "eu-west-2"
    TargetKey                = "tag:OracleDbLTS-ManagedInstance"
    TargetValues             = true
    MaxConcurrency           = 4
    MaxErrors                = 4
  }
  template_body = file("${path.module}/cloudformation/OracleDbLTS-Orchestrate.yaml")

  depends_on = [
    aws_licensemanager_license_configuration.oracle_ec2_licensemanager_configurations
  ]
}

# Trigger automation
resource "aws_ssm_association" "license_manager" {
  name             = "OracleDbLTS-Orchestrate"
  association_name = "OracleDbLicenseTrackingSolutionAssociation"

  schedule_expression = "0 1 * * *"
  max_concurrency = 4
  max_errors      = 4
  parameters = {
    AutomationAssumeRole = "arn:aws:iam::${data.aws_caller_identity.current.id}:role/OracleDbLTS-SystemsManagerAutomationAdministrationRole"
    DeploymentTargets    = local.ou_example
    # DeploymentTargets    = local.ou_modernisation_platform_member_id
    TargetRegions        = "eu-west-2"
  }

  depends_on = [
    aws_cloudformation_stack.oracleblts
  ]
}

# KMS key for resource sync
resource "aws_kms_key" "oracle_licensing" {
  description         = "Used for Oracle Licensing resources"
  policy              = data.aws_iam_policy_document.oracle_kms.json
  is_enabled          = true
  enable_key_rotation = true
}

resource "aws_kms_alias" "oracle_licensing" {
  name          = "alias/oracle-licensing"
  target_key_id = aws_kms_key.oracle_licensing.key_id
}

data "aws_iam_policy_document" "oracle_kms" {
  statement {
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
  statement {
    sid       = "ssm-access-policy-statement"
    effect    = "Allow"
    actions   = ["kms:GenerateDataKey"]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "aws:SourceAccount"
      values   = ["083957762049"]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:ssm:*:083957762049:resource-data-sync/*"]
    }
  }
  statement {
    sid       = "glue-crawler-access"
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

module "oracle_licensing_s3_bucket" {
  source = "../../modules/s3"

  bucket_name = "oracle-license-data-${random_integer.suffix.result}"
  bucket_acl  = "private"

  attach_policy        = true
  policy               = data.aws_iam_policy_document.oracle_licensing_s3_bucket.json
  require_ssl_requests = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

data "aws_iam_policy_document" "oracle_licensing_s3_bucket" {
  statement {
    sid       = "SSMBucketDelivery"
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::oracle-license-data-${random_integer.suffix.result}/*"]

    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = ["245753150946"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = ["083957762049"]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:ssm:*:245753150946:resource-data-sync/*"]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:ssm:*:083957762049:resource-data-sync/*"]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["aws:kms"]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      values   = [aws_kms_key.oracle_licensing.arn]
    }
  }
}

# Athena resources
resource "aws_athena_database" "oracle_licensing" {
  name   = "oracle_dblts"
  bucket = module.oracle_licensing_s3_bucket.bucket_name
}

# resource "aws_athena_named_query" "foo" {
#   name      = "create_oracle_dblts"
#   database  = aws_athena_database.oracle_licensing.name
#   query     = "
# CREATE EXTERNAL TABLE IF NOT EXISTS oracle_dblts.AWS_InstanceDetailedInformation (
# `Cpus` string,
# `osservicepack` string,
# `cpuhyperthreadenabled` string, 
# `cpuspeedmhz` string, 
# `cpusockets` string, 
# `cpucores` string, 
# `cpumodel` string, 
# `resourceid` string, 
# `capturetime` string, 
# `schemaversion` string 
# ) 
# PARTITIONED BY (AccountId string, Region string, ResourceType string) 
# ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe' 
# WITH SERDEPROPERTIES ( 'serialization.format' = '1' ) 
# LOCATION 's3://oracle-license-data-50974883831/AWS:InstanceDetailedInformation/'CREATE EXTERNAL TABLE IF NOT EXISTS oracle_dblts.AWS_InstanceDetailedInformation (
# `Cpus` string,
# `osservicepack` string,
# `cpuhyperthreadenabled` string, 
# `cpuspeedmhz` string, 
# `cpusockets` string, 
# `cpucores` string, 
# `cpumodel` string, 
# `resourceid` string, 
# `capturetime` string, 
# `schemaversion` string 
# ) 
# PARTITIONED BY (AccountId string, Region string, ResourceType string) 
# ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe' 
# WITH SERDEPROPERTIES ( 'serialization.format' = '1' ) 
# LOCATION 's3://oracle-license-data-50974883831/AWS:InstanceDetailedInformation/'
# "}

# MSCK REPAIR TABLE oracle_dblts.AWS_InstanceDetailedInformation;

# Note: You will need to run this statement again as the partition changes (for example, for new accounts, regions, or resource types). Depending on how often these change in your organization, consider using the AWS Glue crawler to automate this step.

# CREATE EXTERNAL TABLE IF NOT EXISTS oracle_dblts.AWS_Tag ( 
# `key` string, 
# `value` string, 
# `resourceid` string, 
# `capturetime` string, 
# `schemaversion` string ) 
# PARTITIONED BY (AccountId string, Region string, ResourceType string) 
# ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe' 
# WITH SERDEPROPERTIES ( 
#   'serialization.format' = '1' 
# ) LOCATION 's3://oracle-license-data-50974883831/AWS:Tag/'

# MSCK REPAIR TABLE oracle_dblts.AWS_Tag

# CREATE EXTERNAL TABLE IF NOT EXISTS oracle_dblts.Custom_SQLServer ( 
# `name` string, 
# `edition` string, 
# `version` string, 
# `resourceid` string, 
# `capturetime` string, 
# `schemaversion` string) 
# PARTITIONED BY (AccountId string, Region string, ResourceType string) 
# ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe' 
# WITH SERDEPROPERTIES (
#  'serialization.format' = '1' 
# ) LOCATION 's3://oracle-license-data-50974883831/Custom:SQLServer/'

# MSCK REPAIR TABLE oracle_dblts.Custom_SQLServer