data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

# Create IAM inline policy - WizFullPolicy
resource "aws_iam_role_policy" "wiz_full_policy" {
  name = "WizFullPolicy${var.iam_policy_suffix}"
  role = aws_iam_role.user-role-tf.id

  policy = jsonencode({
    "Statement" : [
      {
        "Action" : [
          "account:GetContactInformation",
          "acm-pca:GetCertificateAuthorityCertificate",
          "acm:GetCertificate",
          "aiops:ListTagsForResource",
          "amplify:GetApp",
          "amplify:GetBackendEnvironment",
          "amplify:ListApps",
          "amplify:ListBackendEnvironments",
          "amplify:ListBranches",
          "amplify:ListDomainAssociations",
          "amplify:ListTagsForResource",
          "amplifybackend:GetBackend",
          "aoss:BatchGetCollection",
          "aoss:GetAccessPolicy",
          "aoss:GetSecurityPolicy",
          "aoss:ListAccessPolicies",
          "aoss:ListCollections",
          "aoss:ListSecurityPolicies",
          "aoss:ListTagsForResource",
          "apigateway:GET",
          "apigateway:GetPortal",
          "apigateway:GetPortalProduct",
          "apigateway:GetProductPage",
          "apigateway:ListPortalProducts",
          "apigateway:ListPortals",
          "apigateway:ListProductPages",
          "app-integrations:GetApplication",
          "app-integrations:GetDataIntegration",
          "app-integrations:ListApplications",
          "app-integrations:ListDataIntegrations",
          "app-integrations:ListEventIntegrations",
          "appconfig:GetConfigurationProfile",
          "appconfig:GetDeployment",
          "appconfig:GetExtension",
          "appconfig:GetExtensionAssociation",
          "appconfig:ListApplications",
          "appconfig:ListConfigurationProfiles",
          "appconfig:ListDeploymentStrategies",
          "appconfig:ListDeployments",
          "appconfig:ListEnvironments",
          "appconfig:ListExtensionAssociations",
          "appconfig:ListExtensions",
          "appconfig:ListTagsForResource",
          "appfabric:GetAppAuthorization",
          "appfabric:GetAppBundle",
          "appfabric:ListAppAuthorizations",
          "appfabric:ListAppBundles",
          "appfabric:ListTagsForResource",
          "appflow:DescribeConnector",
          "appflow:DescribeConnectorProfiles",
          "appflow:DescribeFlow",
          "appflow:ListConnectors",
          "applicationinsights:ListApplications",
          "applicationinsights:ListTagsForResource",
          "apprunner:ListAssociatedServicesForWebAcl",
          "appstream:DescribeAppBlockBuilders",
          "appstream:DescribeAppBlocks",
          "appstream:DescribeFleets",
          "appstream:DescribeImageBuilders",
          "appstream:DescribeImages",
          "appstream:DescribeStacks",
          "appstream:DescribeUserStackAssociations",
          "appstream:ListAssociatedFleets",
          "appstream:ListTagsForResource",
          "appsync:GetApiAssociation",
          "aps:DescribeAlertManagerDefinition",
          "aps:DescribeLoggingConfiguration",
          "aps:DescribeScraper",
          "aps:ListScrapers",
          "aps:ListWorkspaces",
          "athena:GetDataCatalog",
          "auditmanager:GetAssessment",
          "auditmanager:GetControl",
          "b2bi:GetCapability",
          "b2bi:GetPartnership",
          "b2bi:GetProfile",
          "b2bi:GetTransformer",
          "b2bi:ListCapabilities",
          "b2bi:ListPartnerships",
          "b2bi:ListProfiles",
          "b2bi:ListTagsForResource",
          "b2bi:ListTransformers",
          "backup-gateway:GetGateway",
          "backup-gateway:GetHypervisor",
          "backup-gateway:ListGateways",
          "backup-gateway:ListHypervisors",
          "backup-gateway:ListTagsForResource",
          "backup-search:GetSearchJob",
          "backup-search:GetSearchResultExportJob",
          "backup-search:ListSearchJobs",
          "backup-search:ListSearchResultExportJobs",
          "backup-search:ListTagsForResource",
          "backup:GetBackupPlan",
          "backup:GetBackupSelection",
          "backup:GetLegalHold",
          "backup:GetRestoreTestingPlan",
          "backup:GetTieringConfiguration",
          "backup:ListRestoreTestingPlans",
          "backup:ListTieringConfigurations",
          "batch:DescribeConsumableResource",
          "batch:DescribeJobQueues",
          "batch:DescribeServiceEnvironments",
          "batch:DescribeServiceJob",
          "batch:ListConsumableResources",
          "batch:ListServiceJobs",
          "bedrock-agentcore:GetBrowserSession",
          "bedrock-agentcore:GetResourcePolicy",
          "bedrock-agentcore:GetTokenVault",
          "bedrock-agentcore:ListBrowserSessions",
          "bedrock-agentcore:ListHarnessEndpoints",
          "bedrock-agentcore:ListHarnessVersions",
          "bedrock-agentcore:ListMemoryExtractionJobs",
          "bedrock-agentcore:ListMemoryRecords",
          "bedrock-agentcore:ListPolicyEngineSummaries",
          "bedrock:GetAgent",
          "bedrock:GetAgentActionGroup",
          "bedrock:GetAgentVersion",
          "bedrock:GetDataSource",
          "bedrock:GetGuardrail",
          "bedrock:GetKnowledgeBase",
          "bedrock:ListAgentCollaborators",
          "bedrock:ListEnforcedGuardrailsConfiguration",
          "chatbot:DescribeChimeWebhookConfigurations",
          "chatbot:DescribeSlackChannelConfigurations",
          "chime:GetAccount",
          "chime:GetVoiceConnector",
          "cleanrooms-ml:GetAudienceGenerationJob",
          "cleanrooms-ml:GetAudienceModel",
          "cleanrooms-ml:GetConfiguredAudienceModel",
          "cleanrooms-ml:GetConfiguredModelAlgorithm",
          "cleanrooms-ml:ListAudienceGenerationJobs",
          "cleanrooms-ml:ListAudienceModels",
          "cleanrooms-ml:ListConfiguredAudienceModels",
          "cleanrooms-ml:ListConfiguredModelAlgorithms",
          "clouddirectory:ListTagsForResource",
          "cloudhsm:DescribeClusters",
          "cloudsearch:DescribeAvailabilityOptions",
          "codeartifact:DescribeDomain",
          "codeartifact:DescribeRepository",
          "codeartifact:GetAuthorizationToken",
          "codeartifact:ListDomains",
          "codeartifact:ListPackageVersions",
          "codeartifact:ListPackages",
          "codeartifact:ListTagsForResource",
          "codeartifact:ReadFromRepository",
          "codeconnections:ListConnections",
          "codeconnections:ListHosts",
          "codeconnections:ListTagsForResource",
          "codeguru-profiler:ListProfilingGroups",
          "codeguru-reviewer:DescribeRepositoryAssociation"
        ],
        "Effect" : "Allow",
        "Resource" : "*",
        "Sid" : "WizFullPolicy"
      },
      {
        "Action" : [
          "ec2:CopySnapshot",
          "ec2:CreateSnapshot",
          "ec2:DescribeSnapshots",
          "ec2:GetEbsEncryptionByDefault",
          "kms:CreateKey",
          "kms:DescribeKey"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Action" : [
          "ec2:CreateTags"
        ],
        "Condition" : {
          "StringEquals" : {
            "ec2:CreateAction" : [
              "CopySnapshot",
              "CreateSnapshot"
            ]
          }
        },
        "Effect" : "Allow",
        "Resource" : "arn:${data.aws_partition.current.partition}:ec2:*::snapshot/*",
        "Sid" : "AllowWizToCreateTagsOnCreatedAndCopiedSnapshots"
      },
      {
        "Action" : [
          "ec2:CreateVolume"
        ],
        "Condition" : {
          "StringEquals" : {
            "aws:RequestTag/wiz" : "auto-gen-volume"
          }
        },
        "Effect" : "Allow",
        "Resource" : "*",
        "Sid" : "AllowWizToCreateTaggedVolumes"
      },
      {
        "Action" : [
          "ec2:CreateVolume"
        ],
        "Effect" : "Allow",
        "Resource" : "arn:${data.aws_partition.current.partition}:ec2:*::snapshot/*",
        "Sid" : "AllowWizToCreateTaggedVolumesFromSnapshots"
      },
      {
        "Action" : [
          "ec2:DeleteSnapshot"
        ],
        "Condition" : {
          "StringEquals" : {
            "ec2:ResourceTag/wiz" : "auto-gen-snapshot"
          }
        },
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Action" : [
          "ec2:DeleteVolume"
        ],
        "Condition" : {
          "StringEquals" : {
            "ec2:ResourceTag/wiz" : "auto-gen-volume"
          }
        },
        "Effect" : "Allow",
        "Resource" : "*",
        "Sid" : "AllowWizToDeleteTaggedVolumes"
      },
      {
        "Action" : [
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeVolumes"
        ],
        "Effect" : "Allow",
        "Resource" : "*",
        "Sid" : "WizComplementaryPermissionsForTemporaryVolumes"
      },
      {
        "Action" : [
          "ec2:ModifySnapshotAttribute"
        ],
        "Condition" : {
          "StringEquals" : {
            "ec2:ResourceTag/wiz" : [
              "auto-gen-snapshot",
              "shareable-resource"
            ]
          }
        },
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Action" : [
          "ecr-public:DescribeImages",
          "ecr-public:GetAuthorizationToken",
          "ecr-public:ListTagsForResource",
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:GetAuthorizationToken",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRegistryPolicy",
          "ecr:ListTagsForResource"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Action" : [
          "kms:CreateGrant",
          "kms:ReEncryptFrom"
        ],
        "Condition" : {
          "StringLike" : {
            "kms:ViaService" : "ec2.*.amazonaws.com"
          }
        },
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Action" : [
          "kms:Decrypt"
        ],
        "Condition" : {
          "StringLike" : {
            "kms:ViaService" : "identitystore.*.amazonaws.com"
          }
        },
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Action" : [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ],
        "Condition" : {
          "StringLike" : {
            "kms:ViaService" : "bedrock.*.amazonaws.com"
          }
        },
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Action" : [
          "kms:GetKeyPolicy",
          "kms:PutKeyPolicy"
        ],
        "Condition" : {
          "StringEquals" : {
            "aws:ResourceTag/wiz" : "auto-gen-cmk"
          }
        },
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Action" : "cassandra:Select",
        "Effect" : "Allow",
        "Resource" : [
          "arn:${data.aws_partition.current.partition}:cassandra:*:*:/keyspace/system_multiregion_info/table/tables",
          "arn:${data.aws_partition.current.partition}:cassandra:*:*:/keyspace/system_schema/table/columns",
          "arn:${data.aws_partition.current.partition}:cassandra:*:*:/keyspace/system_schema/table/keyspaces",
          "arn:${data.aws_partition.current.partition}:cassandra:*:*:/keyspace/system_schema/table/tables",
          "arn:${data.aws_partition.current.partition}:cassandra:*:*:/keyspace/system_schema_mcs/table/columns",
          "arn:${data.aws_partition.current.partition}:cassandra:*:*:/keyspace/system_schema_mcs/table/keyspaces",
          "arn:${data.aws_partition.current.partition}:cassandra:*:*:/keyspace/system_schema_mcs/table/tables",
          "arn:${data.aws_partition.current.partition}:cassandra:*:*:/keyspace/system_schema_mcs/table/tags"
        ]
      },
      {
        "Action" : "ec2:CreateTags",
        "Condition" : {
          "StringEquals" : {
            "ec2:CreateAction" : "CreateVolume"
          }
        },
        "Effect" : "Allow",
        "Resource" : "*",
        "Sid" : "AllowWizToCreateTagsOnCreatedVolumes"
      },
      {
        "Action" : "kms:CreateAlias",
        "Effect" : "Allow",
        "Resource" : [
          "arn:${data.aws_partition.current.partition}:kms:*:*:alias/wizKey",
          "arn:${data.aws_partition.current.partition}:kms:*:*:key/*"
        ]
      }
    ],
    "Version" : "2012-10-17"
  })
}

# Create IAM Managed Policy - WizFullPolicy2
resource "aws_iam_policy" "wiz_full_policy2" {
  name = "WizFullPolicy2${var.iam_policy_suffix}"
  policy = jsonencode({
    Statement = local.wiz_full_policy2_statements,
    Version   = "2012-10-17"
  })
}

# Create IAM Managed Policy - WizFullPolicy3
resource "aws_iam_policy" "wiz_full_policy3" {
  name = "WizFullPolicy3${var.iam_policy_suffix}"
  policy = jsonencode({
    Statement = local.wiz_full_policy3_statements,
    Version   = "2012-10-17"
  })
}

# Create IAM Managed Policy - WizFullPolicy4
resource "aws_iam_policy" "wiz_full_policy4" {
  name = "WizFullPolicy4${var.iam_policy_suffix}"
  policy = jsonencode({
    Statement = local.wiz_full_policy4_statements,
    Version   = "2012-10-17"
  })
}

# Create Lightsail Scanning Managed Policy
resource "aws_iam_policy" "wiz_lightsail_policy" {
  name  = "WizLightsailScanningPolicy${var.iam_policy_suffix}"
  count = var.lightsail-scanning ? 1 : 0
  policy = jsonencode({
    "Statement" : [
      {
        "Action" : [
          "ec2:DeleteSnapshot",
          "ec2:ModifySnapshotAttribute"
        ],
        "Condition" : {
          "StringLike" : {
            "ec2:ParentVolume" : "arn:${data.aws_partition.current.partition}:ec2:*:*:volume/vol-ffffffff"
          }
        },
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Action" : [
          "iam:PutRolePolicy"
        ],
        "Effect" : "Allow",
        "Resource" : "arn:${data.aws_partition.current.partition}:iam::*:role/aws-service-role/lightsail.amazonaws.com/AWSServiceRoleForLightsail*"
      },
      {
        "Action" : [
          "lightsail:CreateDiskSnapshot",
          "lightsail:TagResource"
        ],
        "Condition" : {
          "StringEquals" : {
            "aws:RequestTag/wiz" : "auto-gen-snapshot"
          }
        },
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Action" : [
          "lightsail:DeleteDiskSnapshot",
          "lightsail:ExportSnapshot"
        ],
        "Condition" : {
          "StringEquals" : {
            "aws:ResourceTag/wiz" : "auto-gen-snapshot"
          }
        },
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Action" : [
          "lightsail:GetDiskSnapshot",
          "lightsail:GetDiskSnapshots",
          "lightsail:GetExportSnapshotRecords"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Action" : "iam:CreateServiceLinkedRole",
        "Condition" : {
          "StringLike" : {
            "iam:AWSServiceName" : "lightsail.amazonaws.com"
          }
        },
        "Effect" : "Allow",
        "Resource" : "arn:${data.aws_partition.current.partition}:iam::*:role/aws-service-role/lightsail.amazonaws.com/AWSServiceRoleForLightsail*"
      }
    ],
    "Version" : "2012-10-17"
  })
}

# Create Data Scanning Managed Policy
resource "aws_iam_policy" "wiz_policy_data" {
  name  = "WizDataScanningPolicy${var.iam_policy_suffix}"
  count = var.data-scanning ? 1 : 0
  policy = jsonencode({
    "Statement" : [
      {
        "Action" : [
          "dynamodb:DescribeTable",
          "dynamodb:Scan",
          "rds:AddTagsToResource",
          "rds:CopyDBClusterSnapshot",
          "rds:CopyDBSnapshot",
          "rds:DescribeAccountAttributes",
          "rds:DescribeDBClusterSnapshots",
          "rds:DescribeDBClusters",
          "rds:DescribeDBInstances",
          "rds:DescribeDBSnapshots",
          "rds:DescribeDBSubnetGroups",
          "rds:ListTagsForResource",
          "redshift:CopyClusterSnapshot",
          "redshift:DescribeClusterSnapshots",
          "redshift:DescribeClusters",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Action" : [
          "kms:CreateGrant"
        ],
        "Condition" : {
          "StringLike" : {
            "kms:ViaService" : "redshift.*.${data.aws_partition.current.dns_suffix}"
          }
        },
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Action" : [
          "kms:CreateGrant",
          "kms:ReEncrypt*"
        ],
        "Condition" : {
          "StringLike" : {
            "kms:ViaService" : "rds.*.${data.aws_partition.current.dns_suffix}"
          }
        },
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Action" : [
          "rds:CreateDBClusterSnapshot",
          "rds:CreateDBSnapshot"
        ],
        "Condition" : {
          "StringEquals" : {
            "rds:req-tag/wiz" : "auto-gen-snapshot"
          }
        },
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Action" : [
          "rds:DeleteDBClusterSnapshot",
          "rds:ModifyDBClusterSnapshotAttribute"
        ],
        "Effect" : "Allow",
        "Resource" : "arn:${data.aws_partition.current.partition}:rds:*:*:cluster-snapshot:wiz-autogen-*"
      },
      {
        "Action" : [
          "rds:DeleteDBSnapshot",
          "rds:ModifyDBSnapshotAttribute"
        ],
        "Effect" : "Allow",
        "Resource" : "arn:${data.aws_partition.current.partition}:rds:*:*:snapshot:wiz-autogen-*"
      },
      {
        "Action" : [
          "redshift:AuthorizeSnapshotAccess",
          "redshift:DeleteClusterSnapshot",
          "redshift:RevokeSnapshotAccess"
        ],
        "Effect" : "Allow",
        "Resource" : "arn:${data.aws_partition.current.partition}:redshift:*:*:snapshot:*wiz-autogen-*"
      },
      {
        "Action" : [
          "redshift:CreateClusterSnapshot"
        ],
        "Condition" : {
          "StringEquals" : {
            "aws:RequestTag/wiz" : "auto-gen-snapshot"
          }
        },
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Action" : [
          "redshift:CreateTags"
        ],
        "Effect" : "Allow",
        "Resource" : "arn:${data.aws_partition.current.partition}:redshift:*:*:snapshot:*/*"
      }
    ],
    "Version" : "2012-10-17"
  })
}

# Create EKS Scanning inline policy
resource "aws_iam_role_policy" "wiz_policy_eks" {
  name  = "WizEKSScanningPolicy${var.iam_policy_suffix}"
  count = var.eks-scanning ? 1 : 0
  role  = aws_iam_role.user-role-tf.id
  policy = jsonencode({
    "Statement" : [
      {
        "Action" : [
          "eks:AssociateAccessPolicy"
        ],
        "Condition" : {
          "StringEquals" : {
            "eks:policyArn" : "arn:${data.aws_partition.current.partition}:eks::aws:cluster-access-policy/AmazonEKSAdminViewPolicy",
            "eks:principalArn" : "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/${local.wiz_role_name}"
          }
        },
        "Effect" : "Allow",
        "Resource" : [
          "*"
        ],
        "Sid" : "WizAssociateViewOnly"
      },
      {
        "Action" : [
          "eks:CreateAccessEntry"
        ],
        "Condition" : {
          "StringEquals" : {
            "eks:principalArn" : "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/${local.wiz_role_name}"
          }
        },
        "Effect" : "Allow",
        "Resource" : [
          "*"
        ],
        "Sid" : "WizCreateAccessEntry"
      },
      {
        "Action" : [
          "eks:DeleteAccessEntry"
        ],
        "Condition" : {
          "StringEquals" : {
            "aws:ResourceTag/CreatedBy" : "Wiz"
          }
        },
        "Effect" : "Allow",
        "Resource" : [
          "*"
        ],
        "Sid" : "WizDeleteAccessEntry"
      },
      {
        "Action" : [
          "eks:TagResource"
        ],
        "Condition" : {},
        "Effect" : "Allow",
        "Resource" : [
          "arn:${data.aws_partition.current.partition}:eks:*:*:access-entry/*/role/${data.aws_caller_identity.current.account_id}/${local.wiz_role_name}/*"
        ],
        "Sid" : "WizTagAccessEntry"
      }
    ],
    "Version" : "2012-10-17"
  })
}

# Create Wiz Defend Policy
resource "aws_iam_policy" "wiz_defend_policy" {
  name  = "WizDefendPolicy${var.iam_policy_suffix}"
  count = (var.wiz-defend-rds-policy || var.wiz-defend-awslogs-policy || var.wiz-defend-s3-kms-policy) ? 1 : 0

  policy = jsonencode({
    Statement = local.defend_combined_statements,
    Version   = "2012-10-17"
  })
}

# Create Wiz TerraformScanningPolicy
resource "aws_iam_policy" "wiz_terraform_scanning_policy" {
  count = var.terraform-bucket-scanning ? 1 : 0
  name  = "WizTerraformScanningPolicy${var.iam_policy_suffix}"
  policy = jsonencode({
    "Statement" : [
      {
        "Action" : [
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:GetObjectTagging",
          "s3:ListBucket"
        ],
        "Effect" : "Allow",
        "Resource" : [
          "arn:${data.aws_partition.current.partition}:s3:::*cloudtrail*",
          "arn:${data.aws_partition.current.partition}:s3:::*terraform*",
          "arn:${data.aws_partition.current.partition}:s3:::*tf?state*",
          "arn:${data.aws_partition.current.partition}:s3:::*tfstate*",
          "arn:${data.aws_partition.current.partition}:s3:::amplify-*-deployment/*",
          "arn:${data.aws_partition.current.partition}:s3:::elasticbeanstalk-*"
        ],
        "Sid" : "WizTerraformBucketAccess"
      }
    ],
    "Version" : "2012-10-17"
  })
}

# Create Cloud Cost Policy
resource "aws_iam_policy" "wiz_cloud_cost_policy" {
  name  = "WizCloudCostPolicy${var.iam_policy_suffix}"
  count = var.cloud-cost-scanning ? 1 : 0
  policy = jsonencode({
    "Statement" : [
      {
        "Action" : [
          "compute-optimizer:GetAutoScalingGroupRecommendations",
          "compute-optimizer:GetEBSVolumeRecommendations",
          "compute-optimizer:GetEC2InstanceRecommendations",
          "compute-optimizer:GetECSServiceRecommendations",
          "compute-optimizer:GetEnrollmentStatus",
          "compute-optimizer:GetEnrollmentStatusesForOrganization",
          "compute-optimizer:GetIdleRecommendations",
          "compute-optimizer:GetLambdaFunctionRecommendations",
          "compute-optimizer:GetLicenseRecommendations",
          "compute-optimizer:GetRDSDatabaseRecommendations",
          "compute-optimizer:GetRecommendationSummaries"
        ],
        "Effect" : "Allow",
        "Resource" : "*",
        "Sid" : "AllowWizToViewComputeOptimizerRecommendations"
      },
      {
        "Action" : [
          "trustedadvisor:ListChecks",
          "trustedadvisor:ListRecommendationResources",
          "trustedadvisor:ListRecommendations"
        ],
        "Effect" : "Allow",
        "Resource" : "*",
        "Sid" : "AllowWizToCollectTrustedAdvisorRecommendations"
      }
    ],
    "Version" : "2012-10-17"
  })
}

# Attach WizFullPolicy2 to IAM role
resource "aws_iam_role_policy_attachment" "wiz_full_policy2_attach" {
  role       = aws_iam_role.user-role-tf.name
  policy_arn = aws_iam_policy.wiz_full_policy2.arn
}

# Attach WizFullPolicy3 to IAM role
resource "aws_iam_role_policy_attachment" "wiz_full_policy3_attach" {
  role       = aws_iam_role.user-role-tf.name
  policy_arn = aws_iam_policy.wiz_full_policy3.arn
}

# Attach WizFullPolicy4 to IAM role
resource "aws_iam_role_policy_attachment" "wiz_full_policy4_attach" {
  role       = aws_iam_role.user-role-tf.name
  policy_arn = aws_iam_policy.wiz_full_policy4.arn
}

# Attach Lightsail IAM policy to IAM role
resource "aws_iam_role_policy_attachment" "wiz_lightsail_scanning_attach" {
  count      = var.lightsail-scanning ? 1 : 0
  role       = aws_iam_role.user-role-tf.name
  policy_arn = aws_iam_policy.wiz_lightsail_policy[0].arn
}

# Attach Data Scanning IAM policy to IAM role
resource "aws_iam_role_policy_attachment" "wiz_data_scanning_attach" {
  count      = var.data-scanning ? 1 : 0
  role       = aws_iam_role.user-role-tf.name
  policy_arn = aws_iam_policy.wiz_policy_data[0].arn
}

# Attach Wiz Defend to IAM role
resource "aws_iam_role_policy_attachment" "wiz_defend_policy_attach" {
  count      = (var.wiz-defend-rds-policy || var.wiz-defend-awslogs-policy || var.wiz-defend-s3-kms-policy) ? 1 : 0
  role       = aws_iam_role.user-role-tf.name
  policy_arn = aws_iam_policy.wiz_defend_policy[0].arn
}

# Attach Wiz TerraformScanningPolicy to IAM role
resource "aws_iam_role_policy_attachment" "wiz_terraform_scanning_policy_attach" {
  count      = var.terraform-bucket-scanning ? 1 : 0
  role       = aws_iam_role.user-role-tf.name
  policy_arn = aws_iam_policy.wiz_terraform_scanning_policy[0].arn
}

# Attach Cloud Cost IAM policy to IAM role
resource "aws_iam_role_policy_attachment" "wiz_cloud_cost_policy_attach" {
  count      = var.cloud-cost-scanning ? 1 : 0
  role       = aws_iam_role.user-role-tf.name
  policy_arn = aws_iam_policy.wiz_cloud_cost_policy[0].arn
}

locals {
  WizRDSLogsPolicy = [
    {
      "Action" : [
        "rds:DownloadCompleteDBLogFile",
        "rds:DownloadDBLogFilePortion"
      ],
      "Effect" : "Allow",
      "Resource" : "arn:${data.aws_partition.current.partition}:rds:*:*:db:*",
      "Sid" : "WizRDSLogsAccess"
    }
  ]
  WizS3AWSLogsPolicy = [
    {
      "Action" : [
        "s3:GetObject",
        "s3:GetObjectAttributes",
        "s3:GetObjectRetention"
      ],
      "Effect" : "Allow",
      "Resource" : [
        "arn:${data.aws_partition.current.partition}:s3:::*/*/AWSLogs/*",
        "arn:${data.aws_partition.current.partition}:s3:::*/AWSLogs/*"
      ],
      "Sid" : "WizS3AWSLogsGetObject"
    },
    {
      "Action" : [
        "s3:ListBucket"
      ],
      "Condition" : {
        "StringLike" : {
          "s3:prefix" : [
            "*/AWSLogs/*",
            "AWSLogs/*"
          ]
        }
      },
      "Effect" : "Allow",
      "Resource" : [
        "arn:${data.aws_partition.current.partition}:s3:::*"
      ],
      "Sid" : "WizS3AWSLogsListBucket"
    }
  ]
  WizS3KMSDecryptPolicy = [
    {
      "Action" : [
        "kms:Decrypt"
      ],
      "Condition" : {
        "StringLike" : {
          "kms:ViaService" : "s3.*.${data.aws_partition.current.dns_suffix}"
        }
      },
      "Effect" : "Allow",
      "Resource" : "arn:${data.aws_partition.current.partition}:kms:*:*:key/*",
      "Sid" : "WizS3KMSDecrypt"
    }
  ]
  WizS3InventoryPolicy = [
    {
      "Action" : [
        "s3:GetInventoryConfiguration",
        "s3:PutInventoryConfiguration"
      ],
      "Effect" : "Allow",
      "Resource" : "*",
      "Sid" : "WizS3InventoryAccess"
    }
  ]
  WizFullPolicy2 = [
    {
      "Action" : [
        "codeguru-reviewer:ListRepositoryAssociations",
        "codepipeline:ListTagsForResource",
        "codepipeline:ListWebhooks",
        "codestar-notifications:DescribeNotificationRule",
        "codestar-notifications:ListNotificationRules",
        "databrew:DescribeJob",
        "databrew:DescribeRecipe",
        "databrew:ListRecipes",
        "dataexchange:GetAsset",
        "dataexchange:GetDataGrant",
        "dataexchange:GetEventAction",
        "dataexchange:GetRevision",
        "dataexchange:ListDataGrants",
        "dataexchange:ListDataSetRevisions",
        "dataexchange:ListEventActions",
        "dataexchange:ListJobs",
        "dataexchange:ListRevisionAssets",
        "dataexchange:ListTagsForResource",
        "datazone:GetDomain",
        "datazone:ListDomains",
        "datazone:ListTagsForResource",
        "detective:ListOrganizationAdminAccount",
        "detective:ListTagsForResource",
        "devops-guru:DescribeServiceIntegration",
        "devops-guru:ListNotificationChannels",
        "dlm:GetLifecyclePolicies",
        "dlm:GetLifecyclePolicy",
        "docdb-elastic:GetCluster",
        "docdb-elastic:GetClusterSnapshot",
        "docdb-elastic:ListClusterSnapshots",
        "docdb-elastic:ListTagsForResource",
        "drs:DescribeJobs",
        "drs:DescribeLaunchConfigurationTemplates",
        "drs:DescribeRecoveryInstances",
        "drs:DescribeReplicationConfigurationTemplates",
        "drs:DescribeSourceNetworks",
        "drs:DescribeSourceServers",
        "drs:GetRecoveryPlan",
        "drs:ListRecoveryPlans",
        "ds:DescribeEventTopics",
        "ds:DescribeSettings",
        "ds:DescribeSharedDirectories",
        "ds:DescribeTrusts",
        "ds:GetSnapshotLimits",
        "ds:ListCertificates",
        "ds:ListLogSubscriptions",
        "ds:ListTagsForResource",
        "dsql:GetCluster",
        "dsql:ListClusters",
        "ec2:GetVerifiedAccessEndpointPolicy",
        "ecr:BatchGetImage",
        "ecr:DescribePullThroughCacheRules",
        "ecr:GetAuthorizationToken",
        "ecr:GetDownloadUrlForLayer",
        "eks:DescribeAccessEntry",
        "eks:DescribeClusterVersions",
        "eks:DescribePodIdentityAssociation",
        "eks:ListPodIdentityAssociations",
        "entityresolution:GetMatchingWorkflow",
        "entityresolution:GetPolicy",
        "entityresolution:GetSchemaMapping",
        "entityresolution:ListIdNamespaces",
        "entityresolution:ListMatchingWorkflows",
        "entityresolution:ListSchemaMappings",
        "entityresolution:ListTagsForResource",
        "fis:GetExperiment",
        "fis:GetExperimentTemplate",
        "fis:ListActions",
        "fis:ListExperimentTemplates",
        "fis:ListExperiments",
        "frauddetector:ListTagsForResource",
        "gamelift:DescribeAlias",
        "gamelift:DescribeBuild",
        "gamelift:DescribeContainerFleet",
        "gamelift:DescribeFleetAttributes",
        "gamelift:DescribeFleetEvents",
        "gamelift:DescribeGameServerGroup",
        "gamelift:DescribeGameSessionQueues",
        "gamelift:DescribeMatchmakingConfigurations",
        "gamelift:DescribeMatchmakingRuleSets",
        "gamelift:DescribeScript",
        "geo:DescribeGeofenceCollection",
        "geo:DescribeKey",
        "geo:DescribeMap",
        "geo:DescribePlaceIndex",
        "geo:DescribeRouteCalculator",
        "geo:DescribeTracker",
        "geo:ListGeofenceCollections",
        "geo:ListKeys",
        "geo:ListPlaceIndexes",
        "geo:ListRouteCalculators",
        "geo:ListTagsForResource",
        "geo:ListTrackers",
        "glue:GetConnection",
        "glue:GetConnections",
        "glue:GetDatabase",
        "glue:GetMLTransform",
        "glue:GetMLTransforms",
        "glue:GetTables",
        "glue:GetTriggers",
        "glue:GetWorkflow",
        "glue:ListWorkflows",
        "grafana:DescribeWorkspace",
        "greengrass:DescribeComponent",
        "greengrass:GetCoreDevice",
        "greengrass:GetDeployment",
        "healthlake:ListTagsForResource",
        "identitystore:Describe*",
        "identitystore:List*",
        "imagebuilder:GetImage",
        "imagebuilder:GetWorkflow",
        "imagebuilder:ListComponentBuildVersions",
        "imagebuilder:ListComponents",
        "imagebuilder:ListContainerRecipes",
        "imagebuilder:ListDistributionConfigurations",
        "imagebuilder:ListImageBuildVersions",
        "imagebuilder:ListImagePipelines",
        "imagebuilder:ListImageRecipes",
        "imagebuilder:ListImages",
        "imagebuilder:ListInfrastructureConfigurations",
        "imagebuilder:ListLifecyclePolicies",
        "imagebuilder:ListTagsForResource",
        "imagebuilder:ListWorkflowBuildVersions",
        "imagebuilder:ListWorkflows",
        "inspector2:GetCodeSecurityIntegration",
        "inspector2:GetCodeSecurityScanConfiguration",
        "inspector2:GetEc2DeepInspectionConfiguration",
        "inspector2:ListCisScanConfigurations",
        "inspector2:ListCodeSecurityIntegrations",
        "inspector2:ListCodeSecurityScanConfigurations",
        "internetmonitor:GetMonitor",
        "internetmonitor:ListMonitors",
        "internetmonitor:ListTagsForResource",
        "iot:GetCommand",
        "iot:GetOTAUpdate",
        "iot:GetPackage",
        "iot:GetPackageVersion",
        "iot:GetTopicRule",
        "iot:GetTopicRuleDestination",
        "iotanalytics:DescribeChannel",
        "iotanalytics:DescribeDataset",
        "iotanalytics:DescribeDatastore",
        "iotanalytics:DescribePipeline",
        "iotanalytics:ListDatasets",
        "iotanalytics:ListDatastores",
        "iotanalytics:ListPipelines",
        "iotanalytics:ListTagsForResource",
        "iotfleetwise:GetCampaign",
        "iotfleetwise:ListCampaigns",
        "iotfleetwise:ListTagsForResource",
        "iotsitewise:DescribeAssetModel",
        "iotsitewise:DescribePortal",
        "iotsitewise:ListPortals",
        "iotsitewise:ListTagsForResource",
        "iottwinmaker:GetComponentType",
        "iottwinmaker:GetEntity",
        "iottwinmaker:GetScene",
        "iottwinmaker:GetSyncJob",
        "iottwinmaker:GetWorkspace",
        "iottwinmaker:ListComponentTypes",
        "iottwinmaker:ListEntities",
        "iottwinmaker:ListScenes",
        "iottwinmaker:ListSyncJobs",
        "iottwinmaker:ListTagsForResource",
        "kendra:DescribeDataSource",
        "kinesis:GetResourcePolicy",
        "kinesisanalytics:DescribeApplication",
        "kinesisvideo:GetDataEndpoint",
        "lambda:GetFunction",
        "lambda:GetLayerVersion",
        "lex:DescribeBotVersion",
        "lex:ListTagsForResource",
        "lex:ListTestSets",
        "lightsail:GetCertificates",
        "lightsail:GetDiskSnapshot"
      ],
      "Effect" : "Allow",
      "Resource" : "*",
      "Sid" : "WizFullPolicy2"
    }
  ]
  WizFullPolicy3 = [
    {
      "Action" : [
        "lightsail:GetDistributions",
        "lightsail:GetDomain",
        "lightsail:GetDomains",
        "lightsail:GetInstanceSnapshot",
        "lightsail:GetKeyPairs",
        "lightsail:GetRelationalDatabaseSnapshots",
        "lightsail:GetRelationalDatabases",
        "logs:GetDeliveryDestinationPolicy",
        "logs:GetLogAnomalyDetector",
        "logs:GetScheduledQuery",
        "logs:ListLogAnomalyDetectors",
        "logs:ListScheduledQueries",
        "lookoutequipment:DescribeDataset",
        "lookoutequipment:DescribeInferenceScheduler",
        "lookoutequipment:DescribeModel",
        "lookoutequipment:ListInferenceSchedulers",
        "lookoutequipment:ListModels",
        "lookoutequipment:ListTagsForResource",
        "lookoutvision:DescribeProject",
        "macie2:GetAutomatedDiscoveryConfiguration",
        "macie2:GetFindings",
        "macie2:GetMacieSession",
        "managedblockchain:GetAccessor",
        "managedblockchain:GetMember",
        "managedblockchain:GetNetwork",
        "managedblockchain:GetNode",
        "managedblockchain:GetProposal",
        "managedblockchain:ListAccessors",
        "managedblockchain:ListInvitations",
        "managedblockchain:ListMembers",
        "managedblockchain:ListNodes",
        "managedblockchain:ListProposals",
        "managedblockchain:ListTagsForResource",
        "mediaconvert:GetJobTemplate",
        "mediaconvert:GetPreset",
        "mediaconvert:GetQueue",
        "mediaconvert:ListJobTemplates",
        "mediaconvert:ListPresets",
        "mediaconvert:ListQueues",
        "mediaconvert:ListTagsForResource",
        "mediastore:ListTagsForResource",
        "mediatailor:DescribeProgram",
        "mediatailor:GetChannelSchedule",
        "mediatailor:GetPlaybackConfiguration",
        "mediatailor:GetPrefetchSchedule",
        "mediatailor:ListChannels",
        "mediatailor:ListLiveSources",
        "mediatailor:ListPlaybackConfigurations",
        "mediatailor:ListPrefetchSchedules",
        "mediatailor:ListSourceLocations",
        "mediatailor:ListTagsForResource",
        "mediatailor:ListVodSources",
        "medical-imaging:GetDatastore",
        "medical-imaging:ListDatastores",
        "medical-imaging:ListTagsForResource",
        "memorydb:DescribeSnapshots",
        "memorydb:ListTags",
        "neptune-graph:GetGraph",
        "neptune-graph:ListGraphSnapshots",
        "neptune-graph:ListGraphs",
        "neptune-graph:ListTagsForResource",
        "network-firewall:DescribeProxy",
        "network-firewall:DescribeProxyConfiguration",
        "network-firewall:DescribeProxyRuleGroup",
        "network-firewall:DescribeTLSInspectionConfiguration",
        "network-firewall:DescribeVpcEndpointAssociation",
        "network-firewall:ListProxies",
        "network-firewall:ListProxyConfigurations",
        "network-firewall:ListProxyRuleGroups",
        "network-firewall:ListTLSInspectionConfigurations",
        "network-firewall:ListVpcEndpointAssociations",
        "networkmanager:GetCoreNetwork",
        "networkmanager:ListCoreNetworks",
        "networkmonitor:GetMonitor",
        "networkmonitor:ListMonitors",
        "oam:GetSink",
        "oam:ListTagsForResource",
        "omics:GetRun",
        "omics:GetRunCache",
        "omics:GetRunGroup",
        "omics:GetSequenceStore",
        "omics:GetWorkflow",
        "omics:GetWorkflowVersion",
        "omics:ListReadSets",
        "omics:ListReferenceStores",
        "omics:ListReferences",
        "omics:ListRunCaches",
        "omics:ListRunGroups",
        "omics:ListRuns",
        "omics:ListSequenceStores",
        "omics:ListTagsForResource",
        "omics:ListWorkflowVersions",
        "omics:ListWorkflows",
        "osis:GetPipeline",
        "osis:ListPipelines",
        "osis:ListTagsForResource",
        "panorama:DescribeDevice",
        "panorama:DescribePackage",
        "panorama:ListDevices",
        "panorama:ListPackages",
        "payment-cryptography:GetKey",
        "payment-cryptography:ListKeys",
        "payment-cryptography:ListTagsForResource",
        "personalize:DescribeBatchInferenceJob",
        "personalize:DescribeBatchSegmentJob",
        "personalize:DescribeCampaign",
        "personalize:DescribeDataDeletionJob",
        "personalize:DescribeDataset",
        "personalize:DescribeDatasetExportJob",
        "personalize:DescribeDatasetImportJob",
        "personalize:DescribeEventTracker",
        "personalize:DescribeFilter",
        "personalize:DescribeMetricAttribution",
        "personalize:DescribeRecommender",
        "personalize:DescribeSchema",
        "personalize:DescribeSolution",
        "personalize:ListBatchInferenceJobs",
        "personalize:ListBatchSegmentJobs",
        "personalize:ListCampaigns",
        "personalize:ListDataDeletionJobs",
        "personalize:ListDatasetExportJobs",
        "personalize:ListDatasetImportJobs",
        "personalize:ListDatasets",
        "personalize:ListEventTrackers",
        "personalize:ListFilters",
        "personalize:ListMetricAttributions",
        "personalize:ListRecommenders",
        "personalize:ListSchemas",
        "personalize:ListSolutions",
        "personalize:ListTagsForResource",
        "pipes:DescribePipe",
        "pipes:ListPipes",
        "polly:GetLexicon",
        "qbusiness:GetApplication",
        "qbusiness:GetChatResponseConfiguration",
        "qbusiness:GetDataSource",
        "qbusiness:GetIndex",
        "qbusiness:GetWebExperience",
        "qbusiness:ListChatResponseConfigurations",
        "qldb:DescribeJournalKinesisStream",
        "qldb:ListJournalKinesisStreamsForLedger",
        "qldb:ListTagsForResource",
        "ram:GetPermission",
        "rbin:GetRule",
        "rbin:ListRules",
        "rbin:ListTagsForResource",
        "redshift-serverless:GetScheduledAction",
        "redshift-serverless:ListEndpointAccess",
        "redshift-serverless:ListScheduledActions",
        "refactor-spaces:ListApplications",
        "refactor-spaces:ListEnvironments",
        "refactor-spaces:ListRoutes",
        "refactor-spaces:ListServices",
        "resiliencehub:DescribeApp",
        "resiliencehub:DescribeAppAssessment",
        "resiliencehub:ListAppAssessments",
        "resiliencehub:ListApps",
        "resiliencehub:ListRecommendationTemplates",
        "resiliencehub:ListResiliencyPolicies",
        "resiliencehub:ListTagsForResource",
        "resource-groups:GetAccountSettings",
        "resource-groups:GetGroupConfiguration",
        "resource-groups:GetGroupQuery",
        "resource-groups:GetTags",
        "resource-groups:ListGroups",
        "s3:GetIntelligentTieringConfiguration",
        "s3:GetJobTagging",
        "s3:GetStorageLensConfigurationTagging",
        "s3tables:GetTable",
        "s3tables:GetTableBucketEncryption",
        "s3tables:GetTableBucketMetricsConfiguration",
        "s3tables:ListTagsForResource",
        "s3vectors:ListTagsForResource",
        "scheduler:GetSchedule"
      ],
      "Effect" : "Allow",
      "Resource" : "*",
      "Sid" : "WizFullPolicy3"
    }
  ]
  WizFullPolicy4 = [
    {
      "Action" : [
        "scheduler:ListSchedules",
        "scheduler:ListTagsForResource",
        "securitylake:GetDataLakeSources",
        "securitylake:ListDataLakes",
        "securitylake:ListSubscribers",
        "securitylake:ListTagsForResource",
        "serverlessrepo:GetApplication",
        "servicecatalog:DescribePortfolio",
        "servicecatalog:DescribePortfolioShares",
        "servicecatalog:DescribeProductAsAdmin",
        "servicecatalog:SearchProductsAsAdmin",
        "servicediscovery:GetNamespace",
        "servicediscovery:GetService",
        "servicediscovery:ListNamespaces",
        "servicediscovery:ListServices",
        "servicediscovery:ListTagsForResource",
        "ses:GetDedicatedIpPool",
        "ses:GetIngressPoint",
        "ses:GetRuleSet",
        "signer:GetSigningProfile",
        "signer:ListSigningProfiles",
        "snowball:DescribeJob",
        "sns:GetDataProtectionPolicy",
        "sns:GetSubscriptionAttributes",
        "ssm-incidents:GetReplicationSet",
        "ssm-incidents:GetResourcePolicies",
        "ssm-incidents:GetResponsePlan",
        "ssm-incidents:ListReplicationSets",
        "ssm-incidents:ListResponsePlans",
        "ssm-incidents:ListTagsForResource",
        "ssm:GetDocument",
        "ssm:GetParameters",
        "sso-directory:Describe*",
        "sso-directory:ListMembersInGroup",
        "states:ListTagsForResource",
        "storagegateway:DescribeSMBFileShares",
        "storagegateway:DescribeSMBSettings",
        "sts:GetServiceBearerToken",
        "swf:DescribeDomain",
        "textract:GetAdapter",
        "textract:GetAdapterVersion",
        "textract:ListAdapterVersions",
        "textract:ListAdapters",
        "textract:ListTagsForResource",
        "thinclient:GetEnvironment",
        "thinclient:GetSoftwareSet",
        "thinclient:ListEnvironments",
        "thinclient:ListSoftwareSets",
        "thinclient:ListTagsForResource",
        "timestream-influxdb:GetDbCluster",
        "timestream-influxdb:GetDbInstance",
        "timestream-influxdb:GetDbParameterGroup",
        "timestream-influxdb:ListDbClusters",
        "timestream-influxdb:ListDbInstances",
        "timestream-influxdb:ListDbParameterGroups",
        "timestream-influxdb:ListTagsForResource",
        "timestream:DescribeBatchLoadTask",
        "timestream:DescribeEndpoints",
        "timestream:DescribeScheduledQuery",
        "timestream:ListBatchLoadTasks",
        "timestream:ListDatabases",
        "timestream:ListScheduledQueries",
        "timestream:ListTables",
        "timestream:ListTagsForResource",
        "tnb:GetSolFunctionPackage",
        "tnb:GetSolNetworkPackage",
        "tnb:ListSolFunctionPackages",
        "tnb:ListSolNetworkPackages",
        "transcribe:GetCallAnalyticsJob",
        "transcribe:GetMedicalScribeJob",
        "transcribe:GetMedicalTranscriptionJob",
        "transcribe:GetTranscriptionJob",
        "transcribe:ListMedicalScribeJobs",
        "verifiedpermissions:GetPolicyStore",
        "verifiedpermissions:ListPolicyStores",
        "voiceid:ListDomains",
        "vpc-lattice:GetAccessLogSubscription",
        "vpc-lattice:GetAuthPolicy",
        "vpc-lattice:GetResourceConfiguration",
        "vpc-lattice:GetResourceGateway",
        "vpc-lattice:GetService",
        "vpc-lattice:GetServiceNetwork",
        "vpc-lattice:GetServiceNetworkResourceAssociation",
        "vpc-lattice:GetServiceNetworkServiceAssociation",
        "vpc-lattice:GetServiceNetworkVpcAssociation",
        "vpc-lattice:GetTargetGroup",
        "vpc-lattice:ListAccessLogSubscriptions",
        "vpc-lattice:ListDomainVerifications",
        "vpc-lattice:ListResourceConfigurations",
        "vpc-lattice:ListResourceEndpointAssociations",
        "vpc-lattice:ListResourceGateways",
        "vpc-lattice:ListServiceNetworkResourceAssociations",
        "vpc-lattice:ListServiceNetworkServiceAssociations",
        "vpc-lattice:ListServiceNetworkVpcAssociations",
        "vpc-lattice:ListServiceNetworks",
        "vpc-lattice:ListServices",
        "vpc-lattice:ListTagsForResource",
        "vpc-lattice:ListTargetGroups",
        "wafv2:GetIPSet",
        "wafv2:GetRuleGroup",
        "wellarchitected:GetLens",
        "wellarchitected:GetProfile",
        "wellarchitected:GetReviewTemplate",
        "wellarchitected:GetWorkload",
        "wellarchitected:ListLenses",
        "wellarchitected:ListProfiles",
        "wellarchitected:ListReviewTemplates",
        "wellarchitected:ListWorkloads",
        "workmail:GetDefaultRetentionPolicy",
        "workmail:ListAccessControlRules",
        "workmail:ListAvailabilityConfigurations",
        "workmail:ListMailDomains",
        "workmail:ListOrganizations",
        "workmail:ListPersonalAccessTokens",
        "workmail:ListTagsForResource",
        "workspaces-web:GetBrowserSettings",
        "workspaces-web:GetNetworkSettings",
        "workspaces-web:GetPortal",
        "workspaces-web:GetUserSettings",
        "workspaces-web:ListBrowserSettings",
        "workspaces-web:ListNetworkSettings",
        "workspaces-web:ListPortals",
        "workspaces-web:ListTagsForResource",
        "workspaces-web:ListUserSettings"
      ],
      "Effect" : "Allow",
      "Resource" : "*",
      "Sid" : "WizFullPolicy4"
    }
  ]

  rds_statements         = [for stmt in local.WizRDSLogsPolicy : stmt if var.wiz-defend-rds-policy]
  awslogs_statements     = [for stmt in local.WizS3AWSLogsPolicy : stmt if var.wiz-defend-awslogs-policy]
  s3kms_statements       = [for stmt in local.WizS3KMSDecryptPolicy : stmt if var.wiz-defend-s3-kms-policy]
  s3inventory_statements = [for stmt in local.WizS3InventoryPolicy : stmt if var.s3-inventory-scanning]

  defend_combined_statements  = concat(local.rds_statements, local.awslogs_statements, local.s3kms_statements)
  wiz_full_policy2_statements = concat(local.WizFullPolicy2, local.s3inventory_statements)
  wiz_full_policy3_statements = concat(local.WizFullPolicy3)
  wiz_full_policy4_statements = concat(local.WizFullPolicy4)
}
