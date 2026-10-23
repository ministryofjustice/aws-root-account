# Native Terraform deployment of Wiz IAM access in the AWS management account.
# Use this file as a child module inheriting a management-account AWS provider.
# Required inputs: wiz_management_account_id, wiz_external_id, wiz_trust_role_arn.
# No CloudFormation resources, template files, jsonencode policies, or StackSets.
#
# Policy source: https://wizio-public.s3.amazonaws.com/deployment-v2/aws/wiz-aws-standard.json
# Source template version: 2026-10-21. Retrieved 2026-10-23.
# Source SHA256: 4081ebae61dafe47db0f312d0681f6f95b71343038c8637277b35d41756f1ae7
# The source's IAM actions, resources, conditions, policy split, trust and feature
# defaults are preserved. Scalar/list differences in JSON are normalised by the
# policy-document data source. CloudFormation conditions become Terraform bools;
# partition, account and URL-suffix substitutions use AWS provider data sources.
# CloudFormation stack bookkeeping tags are omitted because there is no stack.
# Wiz version metadata is retained, with managed_by = Terraform.
#
# Operates only in the management account. It does not deploy member-account
# resources, enable StackSets trusted access, register delegated administration,
# or create the connector in Wiz. Configure the Wiz connector with the output ARN.
#
# Keep any existing CloudFormation-owned Wiz role/policies out of this module
# until ownership is explicitly migrated. Same-name resources cannot be recreated.
# With eks_scanning enabled, retain role path "/": the vendor's EKS policy
# patterns assume that path. This module enforces that combination explicitly.
# An optional permissions boundary must already exist in this account.
# Vendor feature defaults grant snapshot/KMS access and selected logs/state-file
# access; these policies are more than configuration-only read permissions.
#
# Local checks: terraform validate and mocked plan tests in tests/main.tftest.hcl.
# Review an authenticated Terraform plan before deploying.
# No AWS plan/apply, IAM simulation, or Wiz connector validation has been run.

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0, < 7.0"
    }
  }
}

variable "wiz_management_account_id" {
  type        = string
  description = "Expected management-account ID; guards against deploying through the wrong provider."
  validation {
    condition     = can(regex("^[0-9]{12}$", var.wiz_management_account_id))
    error_message = "Supply the 12-digit AWS management-account ID."
  }
}

variable "wiz_external_id" {
  type        = string
  sensitive   = true
  description = "External ID supplied by the Wiz AWS connector."
  validation {
    condition     = can(regex("^\\S{8}-\\S{4}-\\S{4}-\\S{4}-\\S{12}$", var.wiz_external_id))
    error_message = "Use the UUID-shaped external ID supplied by Wiz."
  }
}

variable "wiz_trust_role_arn" {
  type        = string
  description = "Wiz's own tenant/data-centre trust role ARN (RoleARN in the vendor template), not your deployment role."
  validation {
    condition     = can(regex("^arn:aws(-us-gov|-cn)?:iam::[0-9]{12}:role/.+$", var.wiz_trust_role_arn))
    error_message = "Supply Wiz's trust policy role ARN from the tenant settings."
  }
}

variable "wiz_role_name" {
  type        = string
  default     = "WizAccess-Role"
  description = "Name of the role Wiz assumes in the management account."
}

variable "wiz_role_path" {
  type        = string
  default     = "/"
  description = "IAM role path; retain / when enabling the vendor EKS policy."
  validation {
    condition     = can(regex("^(/|/[!-~]+/)$", var.wiz_role_path))
    error_message = "Role path must be / or begin and end with / without spaces."
  }
}

variable "wiz_policy_name_suffix" {
  type        = string
  default     = ""
  description = "Optional suffix appended to each Wiz policy name."
}

variable "wiz_permission_boundary_policy_name" {
  type        = string
  default     = ""
  description = "Optional existing IAM permissions-boundary policy name (including its path if applicable)."
}

variable "wiz_tags" {
  type    = map(string)
  default = {}
}

variable "wiz_features" {
  description = "Optional feature switches. Defaults match Wiz's 2026-10-21 template."
  type = object({
    cloud_cost_scanning       = optional(bool, true)
    data_scanning             = optional(bool, false)
    eks_scanning              = optional(bool, false)
    lightsail_scanning        = optional(bool, false)
    rds_logs_scanning         = optional(bool, true)
    s3_aws_logs_scanning      = optional(bool, true)
    s3_inventory_scanning     = optional(bool, false)
    s3_kms_decrypt            = optional(bool, true)
    terraform_bucket_scanning = optional(bool, true)
  })
  default = {}
}

data "aws_partition" "wiz_management" {}
data "aws_caller_identity" "wiz_management" {}

data "aws_iam_policy_document" "wiz_management_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [var.wiz_trust_role_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.wiz_external_id]
    }
  }
}

resource "aws_iam_role" "wiz_management" {
  name                 = var.wiz_role_name
  path                 = var.wiz_role_path
  assume_role_policy   = data.aws_iam_policy_document.wiz_management_trust.json
  permissions_boundary = var.wiz_permission_boundary_policy_name == "" ? null : "arn:${data.aws_partition.wiz_management.partition}:iam::${data.aws_caller_identity.wiz_management.account_id}:policy/${var.wiz_permission_boundary_policy_name}"
  tags = merge(var.wiz_tags, {
    managed_by               = "Terraform"
    wiz_version_last_updated = "2026-10-21"
  })

  lifecycle {
    precondition {
      condition     = data.aws_caller_identity.wiz_management.account_id == var.wiz_management_account_id
      error_message = "AWS provider is authenticated to a different account than wiz_management_account_id."
    }
    precondition {
      condition     = !var.wiz_features.eks_scanning || var.wiz_role_path == "/"
      error_message = "The vendor EKS policy assumes the default role path /. Retain / when eks_scanning is enabled."
    }
  }
}

resource "aws_iam_role_policy_attachment" "wiz_management_aws_managed" {
  for_each   = toset(["job-function/ViewOnlyAccess", "SecurityAudit"])
  role       = aws_iam_role.wiz_management.name
  policy_arn = "arn:${data.aws_partition.wiz_management.partition}:iam::aws:policy/${each.value}"
}

# Vendor logical ID: WizCloudCostPolicy
data "aws_iam_policy_document" "wiz_management_cloud_cost" {
  count = var.wiz_features.cloud_cost_scanning ? 1 : 0
  statement {
    sid       = "AllowWizToCollectTrustedAdvisorRecommendations"
    effect    = "Allow"
    actions   = ["trustedadvisor:ListChecks", "trustedadvisor:ListRecommendationResources", "trustedadvisor:ListRecommendations"]
    resources = ["*"]
  }
  statement {
    sid       = "AllowWizToViewComputeOptimizerRecommendations"
    effect    = "Allow"
    actions   = ["compute-optimizer:GetAutoScalingGroupRecommendations", "compute-optimizer:GetEBSVolumeRecommendations", "compute-optimizer:GetEC2InstanceRecommendations", "compute-optimizer:GetECSServiceRecommendations", "compute-optimizer:GetEnrollmentStatus", "compute-optimizer:GetEnrollmentStatusesForOrganization", "compute-optimizer:GetIdleRecommendations", "compute-optimizer:GetLambdaFunctionRecommendations", "compute-optimizer:GetLicenseRecommendations", "compute-optimizer:GetRDSDatabaseRecommendations", "compute-optimizer:GetRecommendationSummaries"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "wiz_management_cloud_cost" {
  count  = var.wiz_features.cloud_cost_scanning ? 1 : 0
  name   = "WizCloudCostPolicy${var.wiz_policy_name_suffix}"
  policy = data.aws_iam_policy_document.wiz_management_cloud_cost[count.index].json
  tags   = var.wiz_tags
}

resource "aws_iam_role_policy_attachment" "wiz_management_cloud_cost" {
  count      = var.wiz_features.cloud_cost_scanning ? 1 : 0
  role       = aws_iam_role.wiz_management.name
  policy_arn = aws_iam_policy.wiz_management_cloud_cost[count.index].arn
}

# Vendor logical ID: WizDataScanningPolicy
data "aws_iam_policy_document" "wiz_management_data_scanning" {
  count = var.wiz_features.data_scanning ? 1 : 0
  statement {
    effect    = "Allow"
    actions   = ["redshift:AuthorizeSnapshotAccess", "redshift:DeleteClusterSnapshot", "redshift:RevokeSnapshotAccess"]
    resources = ["arn:${data.aws_partition.wiz_management.partition}:redshift:*:*:snapshot:*wiz-autogen-*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["redshift:CreateTags"]
    resources = ["arn:${data.aws_partition.wiz_management.partition}:redshift:*:*:snapshot:*/*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["redshift:CreateClusterSnapshot"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/wiz"
      values   = ["auto-gen-snapshot"]
    }
  }
  statement {
    effect    = "Allow"
    actions   = ["dynamodb:DescribeTable", "dynamodb:Scan", "rds:AddTagsToResource", "rds:CopyDBClusterSnapshot", "rds:CopyDBSnapshot", "rds:DescribeAccountAttributes", "rds:DescribeDBClusterSnapshots", "rds:DescribeDBClusters", "rds:DescribeDBInstances", "rds:DescribeDBSnapshots", "rds:DescribeDBSubnetGroups", "rds:ListTagsForResource", "redshift:CopyClusterSnapshot", "redshift:DescribeClusterSnapshots", "redshift:DescribeClusters", "s3:GetObject", "s3:ListBucket"]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["rds:DeleteDBClusterSnapshot", "rds:ModifyDBClusterSnapshotAttribute"]
    resources = ["arn:${data.aws_partition.wiz_management.partition}:rds:*:*:cluster-snapshot:wiz-autogen-*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["rds:DeleteDBSnapshot", "rds:ModifyDBSnapshotAttribute"]
    resources = ["arn:${data.aws_partition.wiz_management.partition}:rds:*:*:snapshot:wiz-autogen-*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["rds:CreateDBClusterSnapshot", "rds:CreateDBSnapshot"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "rds:req-tag/wiz"
      values   = ["auto-gen-snapshot"]
    }
  }
  statement {
    effect    = "Allow"
    actions   = ["kms:CreateGrant", "kms:ReEncrypt*"]
    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "kms:ViaService"
      values   = ["rds.*.${data.aws_partition.wiz_management.dns_suffix}"]
    }
  }
  statement {
    effect    = "Allow"
    actions   = ["kms:CreateGrant"]
    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "kms:ViaService"
      values   = ["redshift.*.${data.aws_partition.wiz_management.dns_suffix}"]
    }
  }
}

resource "aws_iam_policy" "wiz_management_data_scanning" {
  count  = var.wiz_features.data_scanning ? 1 : 0
  name   = "WizDataScanningPolicy${var.wiz_policy_name_suffix}"
  policy = data.aws_iam_policy_document.wiz_management_data_scanning[count.index].json
  tags   = var.wiz_tags
}

resource "aws_iam_role_policy_attachment" "wiz_management_data_scanning" {
  count      = var.wiz_features.data_scanning ? 1 : 0
  role       = aws_iam_role.wiz_management.name
  policy_arn = aws_iam_policy.wiz_management_data_scanning[count.index].arn
}

# Vendor logical ID: WizDefendPolicy
data "aws_iam_policy_document" "wiz_management_defend" {
  count = (var.wiz_features.rds_logs_scanning || var.wiz_features.s3_aws_logs_scanning || var.wiz_features.s3_kms_decrypt) ? 1 : 0
  dynamic "statement" {
    for_each = var.wiz_features.rds_logs_scanning ? [true] : []
    content {
      sid       = "WizRDSLogsAccess"
      effect    = "Allow"
      actions   = ["rds:DownloadCompleteDBLogFile", "rds:DownloadDBLogFilePortion"]
      resources = ["arn:${data.aws_partition.wiz_management.partition}:rds:*:*:db:*"]
    }
  }
  dynamic "statement" {
    for_each = var.wiz_features.s3_aws_logs_scanning ? [true] : []
    content {
      sid       = "WizS3AWSLogsGetObject"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:GetObjectAttributes", "s3:GetObjectRetention"]
      resources = ["arn:${data.aws_partition.wiz_management.partition}:s3:::*/AWSLogs/*", "arn:${data.aws_partition.wiz_management.partition}:s3:::*/*/AWSLogs/*"]
    }
  }
  dynamic "statement" {
    for_each = var.wiz_features.s3_aws_logs_scanning ? [true] : []
    content {
      sid       = "WizS3AWSLogsListBucket"
      effect    = "Allow"
      actions   = ["s3:ListBucket"]
      resources = ["arn:${data.aws_partition.wiz_management.partition}:s3:::*"]

      condition {
        test     = "StringLike"
        variable = "s3:prefix"
        values   = ["AWSLogs/*", "*/AWSLogs/*"]
      }
    }
  }
  dynamic "statement" {
    for_each = var.wiz_features.s3_kms_decrypt ? [true] : []
    content {
      sid       = "WizS3KMSDecrypt"
      effect    = "Allow"
      actions   = ["kms:Decrypt"]
      resources = ["arn:${data.aws_partition.wiz_management.partition}:kms:*:*:key/*"]

      condition {
        test     = "StringLike"
        variable = "kms:ViaService"
        values   = ["s3.*.${data.aws_partition.wiz_management.dns_suffix}"]
      }
    }
  }
}

resource "aws_iam_policy" "wiz_management_defend" {
  count  = (var.wiz_features.rds_logs_scanning || var.wiz_features.s3_aws_logs_scanning || var.wiz_features.s3_kms_decrypt) ? 1 : 0
  name   = "WizDefendPolicy${var.wiz_policy_name_suffix}"
  policy = data.aws_iam_policy_document.wiz_management_defend[count.index].json
  tags   = var.wiz_tags
}

resource "aws_iam_role_policy_attachment" "wiz_management_defend" {
  count      = (var.wiz_features.rds_logs_scanning || var.wiz_features.s3_aws_logs_scanning || var.wiz_features.s3_kms_decrypt) ? 1 : 0
  role       = aws_iam_role.wiz_management.name
  policy_arn = aws_iam_policy.wiz_management_defend[count.index].arn
}

# Vendor logical ID: WizEKSScanningPolicy
data "aws_iam_policy_document" "wiz_management_eks" {
  count = var.wiz_features.eks_scanning ? 1 : 0
  statement {
    sid       = "WizCreateAccessEntry"
    effect    = "Allow"
    actions   = ["eks:CreateAccessEntry"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "eks:principalArn"
      values   = ["arn:${data.aws_partition.wiz_management.partition}:iam::${data.aws_caller_identity.wiz_management.account_id}:role/${var.wiz_role_name}"]
    }
  }
  statement {
    sid       = "WizDeleteAccessEntry"
    effect    = "Allow"
    actions   = ["eks:DeleteAccessEntry"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/CreatedBy"
      values   = ["Wiz"]
    }
  }
  statement {
    sid       = "WizTagAccessEntry"
    effect    = "Allow"
    actions   = ["eks:TagResource"]
    resources = ["arn:${data.aws_partition.wiz_management.partition}:eks:*:*:access-entry/*/role/${data.aws_caller_identity.wiz_management.account_id}/${var.wiz_role_name}/*"]
  }
  statement {
    sid       = "WizAssociateViewOnly"
    effect    = "Allow"
    actions   = ["eks:AssociateAccessPolicy"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "eks:policyArn"
      values   = ["arn:${data.aws_partition.wiz_management.partition}:eks::aws:cluster-access-policy/AmazonEKSAdminViewPolicy"]
    }

    condition {
      test     = "StringEquals"
      variable = "eks:principalArn"
      values   = ["arn:${data.aws_partition.wiz_management.partition}:iam::${data.aws_caller_identity.wiz_management.account_id}:role/${var.wiz_role_name}"]
    }
  }
}

resource "aws_iam_role_policy" "wiz_management_eks" {
  count  = var.wiz_features.eks_scanning ? 1 : 0
  name   = "WizEKSScanningPolicy${var.wiz_policy_name_suffix}"
  role   = aws_iam_role.wiz_management.name
  policy = data.aws_iam_policy_document.wiz_management_eks[count.index].json
}

# Vendor logical ID: WizFullPolicy
data "aws_iam_policy_document" "wiz_management_full" {
  statement {
    sid       = "WizFullPolicy"
    effect    = "Allow"
    actions   = ["account:GetContactInformation", "acm-pca:GetCertificateAuthorityCertificate", "acm:GetCertificate", "aiops:ListTagsForResource", "amplify:GetApp", "amplify:GetBackendEnvironment", "amplify:ListApps", "amplify:ListBackendEnvironments", "amplify:ListBranches", "amplify:ListDomainAssociations", "amplify:ListTagsForResource", "amplifybackend:GetBackend", "aoss:BatchGetCollection", "aoss:GetAccessPolicy", "aoss:GetSecurityPolicy", "aoss:ListAccessPolicies", "aoss:ListCollections", "aoss:ListSecurityPolicies", "aoss:ListTagsForResource", "apigateway:GET", "apigateway:GetPortal", "apigateway:GetPortalProduct", "apigateway:GetProductPage", "apigateway:ListPortalProducts", "apigateway:ListPortals", "apigateway:ListProductPages", "app-integrations:GetApplication", "app-integrations:GetDataIntegration", "app-integrations:ListApplications", "app-integrations:ListDataIntegrations", "app-integrations:ListEventIntegrations", "appconfig:GetConfigurationProfile", "appconfig:GetDeployment", "appconfig:GetExtension", "appconfig:GetExtensionAssociation", "appconfig:ListApplications", "appconfig:ListConfigurationProfiles", "appconfig:ListDeploymentStrategies", "appconfig:ListDeployments", "appconfig:ListEnvironments", "appconfig:ListExtensionAssociations", "appconfig:ListExtensions", "appconfig:ListTagsForResource", "appfabric:GetAppAuthorization", "appfabric:GetAppBundle", "appfabric:ListAppAuthorizations", "appfabric:ListAppBundles", "appfabric:ListTagsForResource", "appflow:DescribeConnector", "appflow:DescribeConnectorProfiles", "appflow:DescribeFlow", "appflow:ListConnectors", "applicationinsights:ListApplications", "applicationinsights:ListTagsForResource", "apprunner:ListAssociatedServicesForWebAcl", "appstream:DescribeAppBlockBuilders", "appstream:DescribeAppBlocks", "appstream:DescribeFleets", "appstream:DescribeImageBuilders", "appstream:DescribeImages", "appstream:DescribeStacks", "appstream:DescribeUserStackAssociations", "appstream:ListAssociatedFleets", "appstream:ListTagsForResource", "appsync:GetApiAssociation", "aps:DescribeAlertManagerDefinition", "aps:DescribeLoggingConfiguration", "aps:DescribeScraper", "aps:ListScrapers", "aps:ListWorkspaces", "athena:GetDataCatalog", "auditmanager:GetAssessment", "auditmanager:GetControl", "b2bi:GetCapability", "b2bi:GetPartnership", "b2bi:GetProfile", "b2bi:GetTransformer", "b2bi:ListCapabilities", "b2bi:ListPartnerships", "b2bi:ListProfiles", "b2bi:ListTagsForResource", "b2bi:ListTransformers", "backup-gateway:GetGateway", "backup-gateway:GetHypervisor", "backup-gateway:ListGateways", "backup-gateway:ListHypervisors", "backup-gateway:ListTagsForResource", "backup-search:GetSearchJob", "backup-search:GetSearchResultExportJob", "backup-search:ListSearchJobs", "backup-search:ListSearchResultExportJobs", "backup-search:ListTagsForResource", "backup:GetBackupPlan", "backup:GetBackupSelection", "backup:GetLegalHold", "backup:GetRestoreTestingPlan", "backup:GetTieringConfiguration", "backup:ListRestoreTestingPlans", "backup:ListTieringConfigurations", "batch:DescribeConsumableResource", "batch:DescribeJobQueues", "batch:DescribeServiceEnvironments", "batch:DescribeServiceJob", "batch:ListConsumableResources", "batch:ListServiceJobs", "bedrock-agentcore:GetBrowserSession", "bedrock-agentcore:GetResourcePolicy", "bedrock-agentcore:GetTokenVault", "bedrock-agentcore:ListBrowserSessions", "bedrock-agentcore:ListHarnessEndpoints", "bedrock-agentcore:ListHarnessVersions", "bedrock-agentcore:ListMemoryExtractionJobs", "bedrock-agentcore:ListMemoryRecords", "bedrock-agentcore:ListPolicyEngineSummaries", "bedrock:GetAgent", "bedrock:GetAgentActionGroup", "bedrock:GetAgentVersion", "bedrock:GetDataSource", "bedrock:GetGuardrail", "bedrock:GetKnowledgeBase", "bedrock:ListAgentCollaborators", "bedrock:ListEnforcedGuardrailsConfiguration", "chatbot:DescribeChimeWebhookConfigurations", "chatbot:DescribeSlackChannelConfigurations", "chime:GetAccount", "chime:GetVoiceConnector", "cleanrooms-ml:GetAudienceGenerationJob", "cleanrooms-ml:GetAudienceModel", "cleanrooms-ml:GetConfiguredAudienceModel", "cleanrooms-ml:GetConfiguredModelAlgorithm", "cleanrooms-ml:ListAudienceGenerationJobs", "cleanrooms-ml:ListAudienceModels", "cleanrooms-ml:ListConfiguredAudienceModels", "cleanrooms-ml:ListConfiguredModelAlgorithms", "clouddirectory:ListTagsForResource", "cloudhsm:DescribeClusters", "cloudsearch:DescribeAvailabilityOptions", "codeartifact:DescribeDomain", "codeartifact:DescribeRepository", "codeartifact:GetAuthorizationToken", "codeartifact:ListDomains", "codeartifact:ListPackageVersions", "codeartifact:ListPackages", "codeartifact:ListTagsForResource", "codeartifact:ReadFromRepository", "codeconnections:ListConnections", "codeconnections:ListHosts", "codeconnections:ListTagsForResource", "codeguru-profiler:ListProfilingGroups", "codeguru-reviewer:DescribeRepositoryAssociation"]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["cassandra:Select"]
    resources = ["arn:${data.aws_partition.wiz_management.partition}:cassandra:*:*:/keyspace/system_schema/table/keyspaces", "arn:${data.aws_partition.wiz_management.partition}:cassandra:*:*:/keyspace/system_schema/table/tables", "arn:${data.aws_partition.wiz_management.partition}:cassandra:*:*:/keyspace/system_schema/table/columns", "arn:${data.aws_partition.wiz_management.partition}:cassandra:*:*:/keyspace/system_schema_mcs/table/keyspaces", "arn:${data.aws_partition.wiz_management.partition}:cassandra:*:*:/keyspace/system_schema_mcs/table/tables", "arn:${data.aws_partition.wiz_management.partition}:cassandra:*:*:/keyspace/system_schema_mcs/table/columns", "arn:${data.aws_partition.wiz_management.partition}:cassandra:*:*:/keyspace/system_schema_mcs/table/tags", "arn:${data.aws_partition.wiz_management.partition}:cassandra:*:*:/keyspace/system_multiregion_info/table/tables"]
  }
  statement {
    effect    = "Allow"
    actions   = ["kms:Decrypt", "kms:GenerateDataKey"]
    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "kms:ViaService"
      values   = ["bedrock.*.amazonaws.com"]
    }
  }
  statement {
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "kms:ViaService"
      values   = ["identitystore.*.amazonaws.com"]
    }
  }
  statement {
    effect    = "Allow"
    actions   = ["ecr-public:DescribeImages", "ecr-public:GetAuthorizationToken", "ecr-public:ListTagsForResource", "ecr:BatchGetImage", "ecr:DescribeImages", "ecr:GetAuthorizationToken", "ecr:GetDownloadUrlForLayer", "ecr:GetRegistryPolicy", "ecr:ListTagsForResource"]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["ec2:CopySnapshot", "ec2:CreateSnapshot", "ec2:DescribeSnapshots", "ec2:GetEbsEncryptionByDefault", "kms:CreateKey", "kms:DescribeKey"]
    resources = ["*"]
  }
  statement {
    sid       = "AllowWizToCreateTagsOnCreatedAndCopiedSnapshots"
    effect    = "Allow"
    actions   = ["ec2:CreateTags"]
    resources = ["arn:${data.aws_partition.wiz_management.partition}:ec2:*::snapshot/*"]

    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"
      values   = ["CreateSnapshot", "CopySnapshot"]
    }
  }
  statement {
    effect    = "Allow"
    actions   = ["kms:CreateAlias"]
    resources = ["arn:${data.aws_partition.wiz_management.partition}:kms:*:*:alias/wizKey", "arn:${data.aws_partition.wiz_management.partition}:kms:*:*:key/*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["kms:CreateGrant", "kms:ReEncryptFrom"]
    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "kms:ViaService"
      values   = ["ec2.*.amazonaws.com"]
    }
  }
  statement {
    effect    = "Allow"
    actions   = ["kms:GetKeyPolicy", "kms:PutKeyPolicy"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/wiz"
      values   = ["auto-gen-cmk"]
    }
  }
  statement {
    effect    = "Allow"
    actions   = ["ec2:DeleteSnapshot"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/wiz"
      values   = ["auto-gen-snapshot"]
    }
  }
  statement {
    effect    = "Allow"
    actions   = ["ec2:ModifySnapshotAttribute"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/wiz"
      values   = ["auto-gen-snapshot", "shareable-resource"]
    }
  }
  statement {
    sid       = "AllowWizToCreateTaggedVolumes"
    effect    = "Allow"
    actions   = ["ec2:CreateVolume"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/wiz"
      values   = ["auto-gen-volume"]
    }
  }
  statement {
    sid       = "AllowWizToCreateTagsOnCreatedVolumes"
    effect    = "Allow"
    actions   = ["ec2:CreateTags"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"
      values   = ["CreateVolume"]
    }
  }
  statement {
    sid       = "AllowWizToCreateTaggedVolumesFromSnapshots"
    effect    = "Allow"
    actions   = ["ec2:CreateVolume"]
    resources = ["arn:${data.aws_partition.wiz_management.partition}:ec2:*::snapshot/*"]
  }
  statement {
    sid       = "AllowWizToDeleteTaggedVolumes"
    effect    = "Allow"
    actions   = ["ec2:DeleteVolume"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/wiz"
      values   = ["auto-gen-volume"]
    }
  }
  statement {
    sid       = "WizComplementaryPermissionsForTemporaryVolumes"
    effect    = "Allow"
    actions   = ["ec2:DescribeAvailabilityZones", "ec2:DescribeVolumes"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "wiz_management_full" {
  name   = "WizFullPolicy${var.wiz_policy_name_suffix}"
  role   = aws_iam_role.wiz_management.name
  policy = data.aws_iam_policy_document.wiz_management_full.json
}

# Vendor logical ID: WizFullPolicy2
data "aws_iam_policy_document" "wiz_management_full_2" {
  statement {
    sid       = "WizFullPolicy2"
    effect    = "Allow"
    actions   = ["codeguru-reviewer:ListRepositoryAssociations", "codepipeline:ListTagsForResource", "codepipeline:ListWebhooks", "codestar-notifications:DescribeNotificationRule", "codestar-notifications:ListNotificationRules", "databrew:DescribeJob", "databrew:DescribeRecipe", "databrew:ListRecipes", "dataexchange:GetAsset", "dataexchange:GetDataGrant", "dataexchange:GetEventAction", "dataexchange:GetRevision", "dataexchange:ListDataGrants", "dataexchange:ListDataSetRevisions", "dataexchange:ListEventActions", "dataexchange:ListJobs", "dataexchange:ListRevisionAssets", "dataexchange:ListTagsForResource", "datazone:GetDomain", "datazone:ListDomains", "datazone:ListTagsForResource", "detective:ListOrganizationAdminAccount", "detective:ListTagsForResource", "devops-guru:DescribeServiceIntegration", "devops-guru:ListNotificationChannels", "dlm:GetLifecyclePolicies", "dlm:GetLifecyclePolicy", "docdb-elastic:GetCluster", "docdb-elastic:GetClusterSnapshot", "docdb-elastic:ListClusterSnapshots", "docdb-elastic:ListTagsForResource", "drs:DescribeJobs", "drs:DescribeLaunchConfigurationTemplates", "drs:DescribeRecoveryInstances", "drs:DescribeReplicationConfigurationTemplates", "drs:DescribeSourceNetworks", "drs:DescribeSourceServers", "drs:GetRecoveryPlan", "drs:ListRecoveryPlans", "ds:DescribeEventTopics", "ds:DescribeSettings", "ds:DescribeSharedDirectories", "ds:DescribeTrusts", "ds:GetSnapshotLimits", "ds:ListCertificates", "ds:ListLogSubscriptions", "ds:ListTagsForResource", "dsql:GetCluster", "dsql:ListClusters", "ec2:GetVerifiedAccessEndpointPolicy", "ecr:BatchGetImage", "ecr:DescribePullThroughCacheRules", "ecr:GetAuthorizationToken", "ecr:GetDownloadUrlForLayer", "eks:DescribeAccessEntry", "eks:DescribeClusterVersions", "eks:DescribePodIdentityAssociation", "eks:ListPodIdentityAssociations", "entityresolution:GetMatchingWorkflow", "entityresolution:GetPolicy", "entityresolution:GetSchemaMapping", "entityresolution:ListIdNamespaces", "entityresolution:ListMatchingWorkflows", "entityresolution:ListSchemaMappings", "entityresolution:ListTagsForResource", "fis:GetExperiment", "fis:GetExperimentTemplate", "fis:ListActions", "fis:ListExperimentTemplates", "fis:ListExperiments", "frauddetector:ListTagsForResource", "gamelift:DescribeAlias", "gamelift:DescribeBuild", "gamelift:DescribeContainerFleet", "gamelift:DescribeFleetAttributes", "gamelift:DescribeFleetEvents", "gamelift:DescribeGameServerGroup", "gamelift:DescribeGameSessionQueues", "gamelift:DescribeMatchmakingConfigurations", "gamelift:DescribeMatchmakingRuleSets", "gamelift:DescribeScript", "geo:DescribeGeofenceCollection", "geo:DescribeKey", "geo:DescribeMap", "geo:DescribePlaceIndex", "geo:DescribeRouteCalculator", "geo:DescribeTracker", "geo:ListGeofenceCollections", "geo:ListKeys", "geo:ListPlaceIndexes", "geo:ListRouteCalculators", "geo:ListTagsForResource", "geo:ListTrackers", "glue:GetConnection", "glue:GetConnections", "glue:GetDatabase", "glue:GetMLTransform", "glue:GetMLTransforms", "glue:GetTables", "glue:GetTriggers", "glue:GetWorkflow", "glue:ListWorkflows", "grafana:DescribeWorkspace", "greengrass:DescribeComponent", "greengrass:GetCoreDevice", "greengrass:GetDeployment", "healthlake:ListTagsForResource", "identitystore:Describe*", "identitystore:List*", "imagebuilder:GetImage", "imagebuilder:GetWorkflow", "imagebuilder:ListComponentBuildVersions", "imagebuilder:ListComponents", "imagebuilder:ListContainerRecipes", "imagebuilder:ListDistributionConfigurations", "imagebuilder:ListImageBuildVersions", "imagebuilder:ListImagePipelines", "imagebuilder:ListImageRecipes", "imagebuilder:ListImages", "imagebuilder:ListInfrastructureConfigurations", "imagebuilder:ListLifecyclePolicies", "imagebuilder:ListTagsForResource", "imagebuilder:ListWorkflowBuildVersions", "imagebuilder:ListWorkflows", "inspector2:GetCodeSecurityIntegration", "inspector2:GetCodeSecurityScanConfiguration", "inspector2:GetEc2DeepInspectionConfiguration", "inspector2:ListCisScanConfigurations", "inspector2:ListCodeSecurityIntegrations", "inspector2:ListCodeSecurityScanConfigurations", "internetmonitor:GetMonitor", "internetmonitor:ListMonitors", "internetmonitor:ListTagsForResource", "iot:GetCommand", "iot:GetOTAUpdate", "iot:GetPackage", "iot:GetPackageVersion", "iot:GetTopicRule", "iot:GetTopicRuleDestination", "iotanalytics:DescribeChannel", "iotanalytics:DescribeDataset", "iotanalytics:DescribeDatastore", "iotanalytics:DescribePipeline", "iotanalytics:ListDatasets", "iotanalytics:ListDatastores", "iotanalytics:ListPipelines", "iotanalytics:ListTagsForResource", "iotfleetwise:GetCampaign", "iotfleetwise:ListCampaigns", "iotfleetwise:ListTagsForResource", "iotsitewise:DescribeAssetModel", "iotsitewise:DescribePortal", "iotsitewise:ListPortals", "iotsitewise:ListTagsForResource", "iottwinmaker:GetComponentType", "iottwinmaker:GetEntity", "iottwinmaker:GetScene", "iottwinmaker:GetSyncJob", "iottwinmaker:GetWorkspace", "iottwinmaker:ListComponentTypes", "iottwinmaker:ListEntities", "iottwinmaker:ListScenes", "iottwinmaker:ListSyncJobs", "iottwinmaker:ListTagsForResource", "kendra:DescribeDataSource", "kinesis:GetResourcePolicy", "kinesisanalytics:DescribeApplication", "kinesisvideo:GetDataEndpoint", "lambda:GetFunction", "lambda:GetLayerVersion", "lex:DescribeBotVersion", "lex:ListTagsForResource", "lex:ListTestSets", "lightsail:GetCertificates", "lightsail:GetDiskSnapshot"]
    resources = ["*"]
  }
  dynamic "statement" {
    for_each = var.wiz_features.s3_inventory_scanning ? [true] : []
    content {
      sid       = "WizS3InventoryAccess"
      effect    = "Allow"
      actions   = ["s3:GetInventoryConfiguration", "s3:PutInventoryConfiguration"]
      resources = ["*"]
    }
  }
}

resource "aws_iam_policy" "wiz_management_full_2" {
  name   = "WizFullPolicy2${var.wiz_policy_name_suffix}"
  policy = data.aws_iam_policy_document.wiz_management_full_2.json
  tags   = var.wiz_tags
}

resource "aws_iam_role_policy_attachment" "wiz_management_full_2" {
  role       = aws_iam_role.wiz_management.name
  policy_arn = aws_iam_policy.wiz_management_full_2.arn
}

# Vendor logical ID: WizFullPolicy3
data "aws_iam_policy_document" "wiz_management_full_3" {
  statement {
    sid       = "WizFullPolicy3"
    effect    = "Allow"
    actions   = ["lightsail:GetDistributions", "lightsail:GetDomain", "lightsail:GetDomains", "lightsail:GetInstanceSnapshot", "lightsail:GetKeyPairs", "lightsail:GetRelationalDatabaseSnapshots", "lightsail:GetRelationalDatabases", "logs:GetDeliveryDestinationPolicy", "logs:GetLogAnomalyDetector", "logs:GetScheduledQuery", "logs:ListLogAnomalyDetectors", "logs:ListScheduledQueries", "lookoutequipment:DescribeDataset", "lookoutequipment:DescribeInferenceScheduler", "lookoutequipment:DescribeModel", "lookoutequipment:ListInferenceSchedulers", "lookoutequipment:ListModels", "lookoutequipment:ListTagsForResource", "lookoutvision:DescribeProject", "macie2:GetAutomatedDiscoveryConfiguration", "macie2:GetFindings", "macie2:GetMacieSession", "managedblockchain:GetAccessor", "managedblockchain:GetMember", "managedblockchain:GetNetwork", "managedblockchain:GetNode", "managedblockchain:GetProposal", "managedblockchain:ListAccessors", "managedblockchain:ListInvitations", "managedblockchain:ListMembers", "managedblockchain:ListNodes", "managedblockchain:ListProposals", "managedblockchain:ListTagsForResource", "mediaconvert:GetJobTemplate", "mediaconvert:GetPreset", "mediaconvert:GetQueue", "mediaconvert:ListJobTemplates", "mediaconvert:ListPresets", "mediaconvert:ListQueues", "mediaconvert:ListTagsForResource", "mediastore:ListTagsForResource", "mediatailor:DescribeProgram", "mediatailor:GetChannelSchedule", "mediatailor:GetPlaybackConfiguration", "mediatailor:GetPrefetchSchedule", "mediatailor:ListChannels", "mediatailor:ListLiveSources", "mediatailor:ListPlaybackConfigurations", "mediatailor:ListPrefetchSchedules", "mediatailor:ListSourceLocations", "mediatailor:ListTagsForResource", "mediatailor:ListVodSources", "medical-imaging:GetDatastore", "medical-imaging:ListDatastores", "medical-imaging:ListTagsForResource", "memorydb:DescribeSnapshots", "memorydb:ListTags", "neptune-graph:GetGraph", "neptune-graph:ListGraphSnapshots", "neptune-graph:ListGraphs", "neptune-graph:ListTagsForResource", "network-firewall:DescribeProxy", "network-firewall:DescribeProxyConfiguration", "network-firewall:DescribeProxyRuleGroup", "network-firewall:DescribeTLSInspectionConfiguration", "network-firewall:DescribeVpcEndpointAssociation", "network-firewall:ListProxies", "network-firewall:ListProxyConfigurations", "network-firewall:ListProxyRuleGroups", "network-firewall:ListTLSInspectionConfigurations", "network-firewall:ListVpcEndpointAssociations", "networkmanager:GetCoreNetwork", "networkmanager:ListCoreNetworks", "networkmonitor:GetMonitor", "networkmonitor:ListMonitors", "oam:GetSink", "oam:ListTagsForResource", "omics:GetRun", "omics:GetRunCache", "omics:GetRunGroup", "omics:GetSequenceStore", "omics:GetWorkflow", "omics:GetWorkflowVersion", "omics:ListReadSets", "omics:ListReferenceStores", "omics:ListReferences", "omics:ListRunCaches", "omics:ListRunGroups", "omics:ListRuns", "omics:ListSequenceStores", "omics:ListTagsForResource", "omics:ListWorkflowVersions", "omics:ListWorkflows", "osis:GetPipeline", "osis:ListPipelines", "osis:ListTagsForResource", "panorama:DescribeDevice", "panorama:DescribePackage", "panorama:ListDevices", "panorama:ListPackages", "payment-cryptography:GetKey", "payment-cryptography:ListKeys", "payment-cryptography:ListTagsForResource", "personalize:DescribeBatchInferenceJob", "personalize:DescribeBatchSegmentJob", "personalize:DescribeCampaign", "personalize:DescribeDataDeletionJob", "personalize:DescribeDataset", "personalize:DescribeDatasetExportJob", "personalize:DescribeDatasetImportJob", "personalize:DescribeEventTracker", "personalize:DescribeFilter", "personalize:DescribeMetricAttribution", "personalize:DescribeRecommender", "personalize:DescribeSchema", "personalize:DescribeSolution", "personalize:ListBatchInferenceJobs", "personalize:ListBatchSegmentJobs", "personalize:ListCampaigns", "personalize:ListDataDeletionJobs", "personalize:ListDatasetExportJobs", "personalize:ListDatasetImportJobs", "personalize:ListDatasets", "personalize:ListEventTrackers", "personalize:ListFilters", "personalize:ListMetricAttributions", "personalize:ListRecommenders", "personalize:ListSchemas", "personalize:ListSolutions", "personalize:ListTagsForResource", "pipes:DescribePipe", "pipes:ListPipes", "polly:GetLexicon", "qbusiness:GetApplication", "qbusiness:GetChatResponseConfiguration", "qbusiness:GetDataSource", "qbusiness:GetIndex", "qbusiness:GetWebExperience", "qbusiness:ListChatResponseConfigurations", "qldb:DescribeJournalKinesisStream", "qldb:ListJournalKinesisStreamsForLedger", "qldb:ListTagsForResource", "ram:GetPermission", "rbin:GetRule", "rbin:ListRules", "rbin:ListTagsForResource", "redshift-serverless:GetScheduledAction", "redshift-serverless:ListEndpointAccess", "redshift-serverless:ListScheduledActions", "refactor-spaces:ListApplications", "refactor-spaces:ListEnvironments", "refactor-spaces:ListRoutes", "refactor-spaces:ListServices", "resiliencehub:DescribeApp", "resiliencehub:DescribeAppAssessment", "resiliencehub:ListAppAssessments", "resiliencehub:ListApps", "resiliencehub:ListRecommendationTemplates", "resiliencehub:ListResiliencyPolicies", "resiliencehub:ListTagsForResource", "resource-groups:GetAccountSettings", "resource-groups:GetGroupConfiguration", "resource-groups:GetGroupQuery", "resource-groups:GetTags", "resource-groups:ListGroups", "s3:GetIntelligentTieringConfiguration", "s3:GetJobTagging", "s3:GetStorageLensConfigurationTagging", "s3tables:GetTable", "s3tables:GetTableBucketEncryption", "s3tables:GetTableBucketMetricsConfiguration", "s3tables:ListTagsForResource", "s3vectors:ListTagsForResource", "scheduler:GetSchedule"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "wiz_management_full_3" {
  name   = "WizFullPolicy3${var.wiz_policy_name_suffix}"
  policy = data.aws_iam_policy_document.wiz_management_full_3.json
  tags   = var.wiz_tags
}

resource "aws_iam_role_policy_attachment" "wiz_management_full_3" {
  role       = aws_iam_role.wiz_management.name
  policy_arn = aws_iam_policy.wiz_management_full_3.arn
}

# Vendor logical ID: WizFullPolicy4
data "aws_iam_policy_document" "wiz_management_full_4" {
  statement {
    sid       = "WizFullPolicy4"
    effect    = "Allow"
    actions   = ["scheduler:ListSchedules", "scheduler:ListTagsForResource", "securitylake:GetDataLakeSources", "securitylake:ListDataLakes", "securitylake:ListSubscribers", "securitylake:ListTagsForResource", "serverlessrepo:GetApplication", "servicecatalog:DescribePortfolio", "servicecatalog:DescribePortfolioShares", "servicecatalog:DescribeProductAsAdmin", "servicecatalog:SearchProductsAsAdmin", "servicediscovery:GetNamespace", "servicediscovery:GetService", "servicediscovery:ListNamespaces", "servicediscovery:ListServices", "servicediscovery:ListTagsForResource", "ses:GetDedicatedIpPool", "ses:GetIngressPoint", "ses:GetRuleSet", "signer:GetSigningProfile", "signer:ListSigningProfiles", "snowball:DescribeJob", "sns:GetDataProtectionPolicy", "sns:GetSubscriptionAttributes", "ssm-incidents:GetReplicationSet", "ssm-incidents:GetResourcePolicies", "ssm-incidents:GetResponsePlan", "ssm-incidents:ListReplicationSets", "ssm-incidents:ListResponsePlans", "ssm-incidents:ListTagsForResource", "ssm:GetDocument", "ssm:GetParameters", "sso-directory:Describe*", "sso-directory:ListMembersInGroup", "states:ListTagsForResource", "storagegateway:DescribeSMBFileShares", "storagegateway:DescribeSMBSettings", "sts:GetServiceBearerToken", "swf:DescribeDomain", "textract:GetAdapter", "textract:GetAdapterVersion", "textract:ListAdapterVersions", "textract:ListAdapters", "textract:ListTagsForResource", "thinclient:GetEnvironment", "thinclient:GetSoftwareSet", "thinclient:ListEnvironments", "thinclient:ListSoftwareSets", "thinclient:ListTagsForResource", "timestream-influxdb:GetDbCluster", "timestream-influxdb:GetDbInstance", "timestream-influxdb:GetDbParameterGroup", "timestream-influxdb:ListDbClusters", "timestream-influxdb:ListDbInstances", "timestream-influxdb:ListDbParameterGroups", "timestream-influxdb:ListTagsForResource", "timestream:DescribeBatchLoadTask", "timestream:DescribeEndpoints", "timestream:DescribeScheduledQuery", "timestream:ListBatchLoadTasks", "timestream:ListDatabases", "timestream:ListScheduledQueries", "timestream:ListTables", "timestream:ListTagsForResource", "tnb:GetSolFunctionPackage", "tnb:GetSolNetworkPackage", "tnb:ListSolFunctionPackages", "tnb:ListSolNetworkPackages", "transcribe:GetCallAnalyticsJob", "transcribe:GetMedicalScribeJob", "transcribe:GetMedicalTranscriptionJob", "transcribe:GetTranscriptionJob", "transcribe:ListMedicalScribeJobs", "verifiedpermissions:GetPolicyStore", "verifiedpermissions:ListPolicyStores", "voiceid:ListDomains", "vpc-lattice:GetAccessLogSubscription", "vpc-lattice:GetAuthPolicy", "vpc-lattice:GetResourceConfiguration", "vpc-lattice:GetResourceGateway", "vpc-lattice:GetService", "vpc-lattice:GetServiceNetwork", "vpc-lattice:GetServiceNetworkResourceAssociation", "vpc-lattice:GetServiceNetworkServiceAssociation", "vpc-lattice:GetServiceNetworkVpcAssociation", "vpc-lattice:GetTargetGroup", "vpc-lattice:ListAccessLogSubscriptions", "vpc-lattice:ListDomainVerifications", "vpc-lattice:ListResourceConfigurations", "vpc-lattice:ListResourceEndpointAssociations", "vpc-lattice:ListResourceGateways", "vpc-lattice:ListServiceNetworkResourceAssociations", "vpc-lattice:ListServiceNetworkServiceAssociations", "vpc-lattice:ListServiceNetworkVpcAssociations", "vpc-lattice:ListServiceNetworks", "vpc-lattice:ListServices", "vpc-lattice:ListTagsForResource", "vpc-lattice:ListTargetGroups", "wafv2:GetIPSet", "wafv2:GetRuleGroup", "wellarchitected:GetLens", "wellarchitected:GetProfile", "wellarchitected:GetReviewTemplate", "wellarchitected:GetWorkload", "wellarchitected:ListLenses", "wellarchitected:ListProfiles", "wellarchitected:ListReviewTemplates", "wellarchitected:ListWorkloads", "workmail:GetDefaultRetentionPolicy", "workmail:ListAccessControlRules", "workmail:ListAvailabilityConfigurations", "workmail:ListMailDomains", "workmail:ListOrganizations", "workmail:ListPersonalAccessTokens", "workmail:ListTagsForResource", "workspaces-web:GetBrowserSettings", "workspaces-web:GetNetworkSettings", "workspaces-web:GetPortal", "workspaces-web:GetUserSettings", "workspaces-web:ListBrowserSettings", "workspaces-web:ListNetworkSettings", "workspaces-web:ListPortals", "workspaces-web:ListTagsForResource", "workspaces-web:ListUserSettings"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "wiz_management_full_4" {
  name   = "WizFullPolicy4${var.wiz_policy_name_suffix}"
  policy = data.aws_iam_policy_document.wiz_management_full_4.json
  tags   = var.wiz_tags
}

resource "aws_iam_role_policy_attachment" "wiz_management_full_4" {
  role       = aws_iam_role.wiz_management.name
  policy_arn = aws_iam_policy.wiz_management_full_4.arn
}

# Vendor logical ID: WizLightsailScanningPolicy
data "aws_iam_policy_document" "wiz_management_lightsail" {
  count = var.wiz_features.lightsail_scanning ? 1 : 0
  statement {
    effect    = "Allow"
    actions   = ["iam:CreateServiceLinkedRole"]
    resources = ["arn:${data.aws_partition.wiz_management.partition}:iam::*:role/aws-service-role/lightsail.amazonaws.com/AWSServiceRoleForLightsail*"]

    condition {
      test     = "StringLike"
      variable = "iam:AWSServiceName"
      values   = ["lightsail.amazonaws.com"]
    }
  }
  statement {
    effect    = "Allow"
    actions   = ["iam:PutRolePolicy"]
    resources = ["arn:${data.aws_partition.wiz_management.partition}:iam::*:role/aws-service-role/lightsail.amazonaws.com/AWSServiceRoleForLightsail*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["lightsail:CreateDiskSnapshot", "lightsail:TagResource"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/wiz"
      values   = ["auto-gen-snapshot"]
    }
  }
  statement {
    effect    = "Allow"
    actions   = ["lightsail:DeleteDiskSnapshot", "lightsail:ExportSnapshot"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/wiz"
      values   = ["auto-gen-snapshot"]
    }
  }
  statement {
    effect    = "Allow"
    actions   = ["lightsail:GetDiskSnapshot", "lightsail:GetDiskSnapshots", "lightsail:GetExportSnapshotRecords"]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["ec2:DeleteSnapshot", "ec2:ModifySnapshotAttribute"]
    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "ec2:ParentVolume"
      values   = ["arn:${data.aws_partition.wiz_management.partition}:ec2:*:*:volume/vol-ffffffff"]
    }
  }
}

resource "aws_iam_policy" "wiz_management_lightsail" {
  count  = var.wiz_features.lightsail_scanning ? 1 : 0
  name   = "WizLightsailScanningPolicy${var.wiz_policy_name_suffix}"
  policy = data.aws_iam_policy_document.wiz_management_lightsail[count.index].json
  tags   = var.wiz_tags
}

resource "aws_iam_role_policy_attachment" "wiz_management_lightsail" {
  count      = var.wiz_features.lightsail_scanning ? 1 : 0
  role       = aws_iam_role.wiz_management.name
  policy_arn = aws_iam_policy.wiz_management_lightsail[count.index].arn
}

# Vendor logical ID: WizTerraformScanningPolicy
data "aws_iam_policy_document" "wiz_management_terraform" {
  count = var.wiz_features.terraform_bucket_scanning ? 1 : 0
  statement {
    sid       = "WizTerraformBucketAccess"
    effect    = "Allow"
    actions   = ["s3:GetBucketLocation", "s3:GetObject", "s3:GetObjectTagging", "s3:ListBucket"]
    resources = ["arn:${data.aws_partition.wiz_management.partition}:s3:::*terraform*", "arn:${data.aws_partition.wiz_management.partition}:s3:::*tfstate*", "arn:${data.aws_partition.wiz_management.partition}:s3:::*tf?state*", "arn:${data.aws_partition.wiz_management.partition}:s3:::*cloudtrail*", "arn:${data.aws_partition.wiz_management.partition}:s3:::elasticbeanstalk-*", "arn:${data.aws_partition.wiz_management.partition}:s3:::amplify-*-deployment/*"]
  }
}

resource "aws_iam_policy" "wiz_management_terraform" {
  count  = var.wiz_features.terraform_bucket_scanning ? 1 : 0
  name   = "WizTerraformScanningPolicy${var.wiz_policy_name_suffix}"
  policy = data.aws_iam_policy_document.wiz_management_terraform[count.index].json
  tags   = var.wiz_tags
}

resource "aws_iam_role_policy_attachment" "wiz_management_terraform" {
  count      = var.wiz_features.terraform_bucket_scanning ? 1 : 0
  role       = aws_iam_role.wiz_management.name
  policy_arn = aws_iam_policy.wiz_management_terraform[count.index].arn
}

output "wiz_management_role_arn" {
  value       = aws_iam_role.wiz_management.arn
  description = "Role ARN to configure for management-account access in Wiz."
}
