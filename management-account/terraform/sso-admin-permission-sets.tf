#######################
# Generic permissions #
#######################

# AdministratorAccess
resource "aws_ssoadmin_permission_set" "administrator_access" {
  name             = "AdministratorAccess"
  description      = "Full AWS administrator access"
  instance_arn     = local.sso_admin_instance_arn
  session_duration = "PT1H"
  tags             = {}
}

resource "aws_ssoadmin_managed_policy_attachment" "administrator_access" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  permission_set_arn = aws_ssoadmin_permission_set.administrator_access.arn
}

# AWS SSO Read Only
resource "aws_ssoadmin_permission_set" "aws_sso_read_only" {
  name             = "AWSSSOReadOnly"
  description      = "Read-only access to AWS SSO"
  instance_arn     = local.sso_admin_instance_arn
  session_duration = "PT1H"
  tags             = {}
}

resource "aws_ssoadmin_managed_policy_attachment" "aws_sso_read_only_lambda" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AWSLambda_ReadOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.aws_sso_read_only.arn
}

resource "aws_ssoadmin_managed_policy_attachment" "aws_sso_read_only_sso" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AWSSSOReadOnly"
  permission_set_arn = aws_ssoadmin_permission_set.aws_sso_read_only.arn
}

resource "aws_ssoadmin_managed_policy_attachment" "aws_sso_read_only_directory" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AWSSSODirectoryReadOnly"
  permission_set_arn = aws_ssoadmin_permission_set.aws_sso_read_only.arn
}

resource "aws_ssoadmin_managed_policy_attachment" "aws_sso_read_only_ec2" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.aws_sso_read_only.arn
}

# SSO Admin

resource "aws_ssoadmin_permission_set" "aws_sso_admin" {
  name             = "AWSSSOAdmin"
  description      = "Admin access to AWS SSO"
  instance_arn     = local.sso_admin_instance_arn
  session_duration = "PT1H"
  tags             = {}
}

resource "aws_ssoadmin_managed_policy_attachment" "aws_sso_admin_lambda" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
  permission_set_arn = aws_ssoadmin_permission_set.aws_sso_admin.arn
}

resource "aws_ssoadmin_managed_policy_attachment" "aws_sso_admin_sso" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AWSSSOMasterAccountAdministrator"
  permission_set_arn = aws_ssoadmin_permission_set.aws_sso_admin.arn
}

resource "aws_ssoadmin_managed_policy_attachment" "aws_sso_admin_read_only_access" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.aws_sso_admin.arn
}

resource "aws_ssoadmin_managed_policy_attachment" "aws_sso_admin_secrets_manager_read_write" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  permission_set_arn = aws_ssoadmin_permission_set.aws_sso_admin.arn
}

# Billing Access
resource "aws_ssoadmin_permission_set" "billing" {
  name             = "Billing"
  description      = "Billing-only access"
  instance_arn     = local.sso_admin_instance_arn
  session_duration = "PT8H"
  tags             = {}
}

resource "aws_ssoadmin_permission_set_inline_policy" "billing" {
  instance_arn       = local.sso_admin_instance_arn
  inline_policy      = data.aws_iam_policy_document.billing.json
  permission_set_arn = aws_ssoadmin_permission_set.billing.arn
}

data "aws_iam_policy_document" "billing" {
  statement {
    sid       = "BCMDataExports"
    effect    = "Allow"
    actions   = ["bcm-data-exports:*"]
    resources = ["*"]
  }
}

resource "aws_ssoadmin_managed_policy_attachment" "billing" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/job-function/Billing"
  permission_set_arn = aws_ssoadmin_permission_set.billing.arn
}

# Read Only Access
resource "aws_ssoadmin_permission_set" "read_only_access" {
  name             = "ReadOnlyAccess"
  description      = "Read-only access"
  instance_arn     = local.sso_admin_instance_arn
  session_duration = "PT1H"
  tags             = {}
}

resource "aws_ssoadmin_managed_policy_attachment" "read_only_access" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.read_only_access.arn
}

# Custom read-only permissions for Data Exports
resource "aws_ssoadmin_permission_set_inline_policy" "read_only_access_custom" {
  instance_arn       = local.sso_admin_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.read_only_access.arn

  inline_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [

          "bcm-data-exports:GetExport",
          "bcm-data-exports:ListExports",
          "bcm-data-exports:GetExecution",
          "bcm-data-exports:ListExecutions",
          "bcm-data-exports:GetTable",
          "bcm-data-exports:ListTables",
          "bcm-data-exports:ListTagsForResource",
          "cur:DescribeReportDefinitions"
        ],
        Resource = "*"
      }
    ]
  })
}

# Security Audit
resource "aws_ssoadmin_permission_set" "security_audit" {
  name             = "SecurityAudit"
  description      = "Security auditor access"
  instance_arn     = local.sso_admin_instance_arn
  session_duration = "PT1H"
  tags             = {}
}

resource "aws_ssoadmin_managed_policy_attachment" "security_audit" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
  permission_set_arn = aws_ssoadmin_permission_set.security_audit.arn
}

resource "aws_ssoadmin_managed_policy_attachment" "security_audit_inspector_v2" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AmazonInspector2ReadOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.security_audit.arn
}

resource "aws_ssoadmin_permission_set_inline_policy" "security_audit_additional" {
  instance_arn       = local.sso_admin_instance_arn
  inline_policy      = data.aws_iam_policy_document.security_audit.json
  permission_set_arn = aws_ssoadmin_permission_set.security_audit.arn
}

data "aws_iam_policy_document" "security_audit" {
  statement {
    actions = [
      "support:*"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "SecurityAuditAdditionalAllow"
    effect = "Allow"
    actions = [
      "aoss:BatchGet*",
      "aoss:Get*",
      "aoss:List*",
      "cloudwatch:Get*",
      "es:Describe*",
      "es:ESHttpGet",
      "es:Get*",
      "es:List",
      "osis:Get",
      "osis:List"
    ]
    resources = ["*"]
  }
}

# Support
resource "aws_ssoadmin_permission_set" "support" {
  name             = "Support"
  description      = "This policy grants permissions to troubleshoot and resolve issues in an AWS account. This policy also enables the user to contact AWS support to create and manage cases."
  instance_arn     = local.sso_admin_instance_arn
  session_duration = "PT1H"
  tags             = {}
}

resource "aws_ssoadmin_managed_policy_attachment" "support" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/job-function/SupportUser"
  permission_set_arn = aws_ssoadmin_permission_set.support.arn
}

# View Only Access
resource "aws_ssoadmin_permission_set" "view_only_access" {
  name             = "ViewOnlyAccess"
  description      = "View-only access"
  instance_arn     = local.sso_admin_instance_arn
  session_duration = "PT1H"
  tags             = {}
}

resource "aws_ssoadmin_managed_policy_attachment" "view_only_access" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.view_only_access.arn
}

##################################################
# Modernisation Platform specific permision sets #
##################################################


# Modernisation Platform engineer
# This role is designed to be used as an alternative to a full on admin role

resource "aws_ssoadmin_permission_set" "modernisation_platform_engineer" {
  name             = "ModernisationPlatformEngineer"
  description      = "Modernisation Platform: engineer troubleshooting role"
  instance_arn     = local.sso_admin_instance_arn
  session_duration = "PT8H"
  tags             = {}
}

resource "aws_ssoadmin_managed_policy_attachment" "modernisation_platform_engineer" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.modernisation_platform_engineer.arn
}

resource "aws_ssoadmin_permission_set_inline_policy" "modernisation_platform_engineer" {
  instance_arn       = local.sso_admin_instance_arn
  inline_policy      = data.aws_iam_policy_document.modernisation_platform_engineer.json
  permission_set_arn = aws_ssoadmin_permission_set.modernisation_platform_engineer.arn
}

data "aws_iam_policy_document" "modernisation_platform_engineer" {
  statement {
    actions = [
      "support:*"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "ModernisationPlatformEngineerAdditionalAllow"
    effect = "Allow"
    actions = [
      "acm:ImportCertificate",
      "acm:AddTagsToCertificate",
      "acm:RemoveTagsFromCertificate",
      "autoscaling:StartInstanceRefresh",
      "autoscaling:UpdateAutoScalingGroup",
      "autoscaling:SetDesiredCapacity",
      "athena:Get*",
      "athena:List*",
      "athena:St*",
      "bcm-data-exports:GetExport",
      "bcm-data-exports:ListExports",
      "bcm-data-exports:GetExecution",
      "bcm-data-exports:ListExecutions",
      "bcm-data-exports:GetTable",
      "bcm-data-exports:ListTables",
      "bcm-data-exports:ListTagsForResource",
      "aws-marketplace:ViewSubscriptions",
      "cloudformation:DeleteStack",
      "cloudformation:DeleteStackInstances",
      "cloudformation:DeleteStackSet",
      "cloudwatch:DisableAlarmActions",
      "cloudwatch:EnableAlarmActions",
      "cloudwatch:PutDashboard",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DeleteDashboards",
      "codebuild:ImportSourceCredentials",
      "codebuild:PersistOAuthToken",
      "cur:DescribeReportDefinitions",
      "ds:*Tags*",
      "ds:*Snapshot*",
      "ds:ResetUserPassword",
      "dynamodb:BatchGet*",
      "ec2:AttachVolume",
      "ec2:St*",
      "ec2:RebootInstances",
      "ec2:Modify*",
      "ec2:CopyImage",
      "ec2:CreateImage",
      "ec2:CreateVolume",
      "ec2:CopySnapshot",
      "ec2:CreateSnapshot*",
      "ec2:CreateTags",
      "ec2:DetachVolume",
      "ec2:ImportImage",
      "ec2:ImportSnapshot",
      "ec2:RegisterImage",
      "ec2:*SerialConsole*",
      "ec2:ModifyInstanceAttribute",
      "ec2-instance-connect:SendSerialConsoleSSHPublicKey",
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchDeleteImage",
      "ecr:CompleteLayerUpload",
      "ecr:GetAuthorizationToken",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
      "ecs:StartTask",
      "ecs:StopTask",
      "ecs:UpdateService",
      "ecs:ExecuteCommand",
      "eks:AccessKubernetesApi",
      "eks:Describe*",
      "eks:List*",
      "events:DisableRule",
      "events:EnableRule",
      "kms:Decrypt*",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:CreateGrant",
      "lambda:InvokeFunction",
      "lambda:UpdateFunctionCode",
      "oam:ListTagsForResource",
      "rds:AddTagsToResource",
      "rds:CopyDB*",
      "rds:Create*",
      "rds:ModifyDBSnapshotAttribute",
      "rds:RestoreDBInstanceToPointInTime",
      "rds:RebootDB*",
      "rhelkb:GetRhelURL",
      "q:*",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
      "s3:RestoreObject",
      "s3:*StorageLens*",
      "secretsmanager:Get*",
      "secretsmanager:PutSecretValue",
      "secretsmanager:UpdateSecret",
      "secretsmanager:RestoreSecret",
      "secretsmanager:RotateSecret",
      "servicequotas:*",
      "ses:DeleteSuppressedDestination",
      "ses:PutAccountDetails",
      "ssm:*",
      "ssm-guiconnect:*",
      "sns:Publish",
      "sso:ListDirectoryAssociations",
      "support:*",
      "wellarchitected:Get*",
      "wellarchitected:List*",
      "wellarchitected:ExportLens",
      "states:Describe*",
      "states:List*",
      "states:Stop*",
      "states:Start*",
      "kms:CreateGrant",
      "kinesisanalytics:StartApplication",
      "kinesisanalytics:StopApplication",
      "kinesisanalytics:CreateApplicationSnapshot",
      "kinesisanalytics:List*",
      "kinesisanalytics:Describe*",
      "kinesisanalytics:DiscoverInputSchema",
      "kinesisanalytics:RollbackApplication",
      "glue:GetConnections",
      "glue:GetTables",
      "glue:GetPartitions",
      "glue:BatchGetPartition",
      "glue:GetDatabases",
      "glue:GetTable",
      "glue:GetDatabase",
      "glue:GetPartition",
      "glue:StartJobRun",
      "glue:BatchStopJobRun",
      "glue:ResetJobBookmark",
      "glue:UpdateJob",
      "glue:UseGlueStudio",
      "glue:GetJobs",
      "glue:GetJobRun",
      "glue:GetJobRuns",
      "glue:StartTrigger",
      "glue:StopTrigger"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "AllowStateLock"
    effect = "Allow"
    actions = [
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]
    resources = ["arn:aws:dynamodb:eu-west-2:${coalesce(local.modernisation_platform_accounts.modernisation_platform_id...)}:table/modernisation-platform-terraform-state-lock"]
  }
  statement {
    sid    = "ModPlatAccountsAllowMoveFromOUToRoot"
    effect = "Allow"
    actions = [
      "organizations:MoveAccount"
    ]
    resources = [

      # move will only succeed if the source OU is authorized below.
      "arn:aws:organizations::${data.aws_caller_identity.current.account_id}:account/${aws_organizations_organization.default.id}/*",

      # specific source OU we are allowing accounts to be moved from
      "arn:aws:organizations::${data.aws_caller_identity.current.account_id}:ou/${aws_organizations_organization.default.id}/${aws_organizations_organizational_unit.platforms_and_architecture_modernisation_platform.id}",

      # Any nested OUs under the parent OU
      "arn:aws:organizations::${data.aws_caller_identity.current.account_id}:ou/${aws_organizations_organization.default.id}/*",

      # Destination for moved account
      "arn:aws:organizations::${data.aws_caller_identity.current.account_id}:root/${aws_organizations_organization.default.id}/${aws_organizations_organization.default.roots[0].id}"
    ]
  }
}

# Modernisation Platform end user permission sets are now managed in the modernisation-platform repository

################################
# OPG specific permission sets #
################################

# OPG Breakglass
resource "aws_ssoadmin_permission_set" "opg_breakglass" {
  name             = "opg-breakglass"
  description      = "Breakglass role given to the webops engineers at OPG incase of emergencies"
  instance_arn     = local.sso_admin_instance_arn
  session_duration = "PT1H"
  tags             = {}
}

resource "aws_ssoadmin_managed_policy_attachment" "opg_breakglass" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  permission_set_arn = aws_ssoadmin_permission_set.opg_breakglass.arn
}

# OPG Operator
resource "aws_ssoadmin_permission_set" "opg_operator" {
  name             = "opg-operator"
  description      = "Standard operator role given to an OPG Digital product's team members"
  instance_arn     = local.sso_admin_instance_arn
  session_duration = "PT2H"
  tags             = {}
}

resource "aws_ssoadmin_managed_policy_attachment" "opg_operator" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.opg_operator.arn
}

resource "aws_ssoadmin_managed_policy_attachment" "opg_operator_billing" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AWSBillingReadOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.opg_operator.arn
}

resource "aws_ssoadmin_permission_set_inline_policy" "opg_operator" {
  instance_arn       = local.sso_admin_instance_arn
  inline_policy      = data.aws_iam_policy_document.opg_operator.json
  permission_set_arn = aws_ssoadmin_permission_set.opg_operator.arn
}

data "aws_iam_policy_document" "opg_operator" {
  statement {
    sid       = "AdminsManageSecrets"
    effect    = "Allow"
    actions   = ["secretsmanager:*"]
    resources = ["*"]
  }

  statement {
    sid    = "GetCostForecastAndUsage"
    effect = "Allow"

    actions = [
      "ce:GetCostForecast",
      "ce:GetCostAndUsage",
    ]

    resources = ["*"]
  }
  statement {
    sid    = "UalCiIdentityCognitoAccess"
    effect = "Allow"
    actions = [
      "cognito:*",
      "cognito-idp:*",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Support"
    effect = "Allow"

    actions = [
      "support:*",
      "trustedadvisor:*",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "SNSSubscriptions"
    effect = "Allow"

    actions = [
      "sns:subscribe",
      "sns:unsubscribe",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "ECSRunTask"
    effect = "Allow"

    actions = [
      "ecs:RunTask",
      "iam:PassRole",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "APIGatewayInvoke"
    effect = "Allow"

    actions = [
      "execute-api:Invoke",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "CloudwatchAccess"
    effect = "Allow"

    actions = [
      "cloudwatch:DescribeAlarms",
      "applicationinsights:ListApplications",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "HealthEvents"
    effect = "Allow"

    actions = [
      "health:DescribeEventAggregates",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "DynamoDBDescribeTables"
    effect = "Allow"

    actions = [
      "dynamodb:*Describe*",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "ForbidDynamoDBAccess1"
    effect = "Deny"

    actions = [
      "dynamodb:*Batch*",
      "dynamodb:*Create*",
      "dynamodb:*Delete*",
      "dynamodb:*Get*",
      "dynamodb:*Update*",
      "dynamodb:*Tag*",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "ForbidDynamoDBAccess2"
    effect = "Deny"

    actions = [
      "dynamodb:ConditionCheckItem",
      "dynamodb:PurchaseReservedCapacityOfferings",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:RestoreTableFromBackup",
      "dynamodb:RestoreTableToPointInTime",
      "dynamodb:Scan",
    ]

    resources = ["*"]
  }
}

# OPG Security Audit
resource "aws_ssoadmin_permission_set" "opg_security_audit" {
  name             = "opg-security-audit"
  description      = "Allow SecOps access into OPG accounts"
  instance_arn     = local.sso_admin_instance_arn
  session_duration = "PT1H"
  tags             = {}
}

resource "aws_ssoadmin_managed_policy_attachment" "opg_security_audit_guardduty" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AmazonGuardDutyReadOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.opg_security_audit.arn
}

resource "aws_ssoadmin_managed_policy_attachment" "opg_security_audit" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
  permission_set_arn = aws_ssoadmin_permission_set.opg_security_audit.arn
}

resource "aws_ssoadmin_managed_policy_attachment" "opg_security_audit_securityhub" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AWSSecurityHubReadOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.opg_security_audit.arn
}

resource "aws_ssoadmin_managed_policy_attachment" "opg_security_audit_cloudtrail" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AWSCloudTrail_ReadOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.opg_security_audit.arn
}

# OPG Viewer
resource "aws_ssoadmin_permission_set" "opg_viewer" {
  name             = "opg-viewer"
  description      = "Standard viewer role given to all members of OPG Digital"
  instance_arn     = local.sso_admin_instance_arn
  session_duration = "PT2H"
  tags             = {}
}

resource "aws_ssoadmin_managed_policy_attachment" "opg_viewer" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.opg_viewer.arn
}

#########################################
# Technology Operations permission sets #
#########################################

# Technology Operations operator
# The Technical Operations role provides users with read-only access,
# but with the following additional permissions:
# - allow managing EC2 instances
# - allow releasing of CodePipelines
# - allow access to support:*
# - allow updating SSM Parameters:*
resource "aws_ssoadmin_permission_set" "techops_operator" {
  name             = "techops-operator"
  description      = "Technical Operations operator"
  instance_arn     = local.sso_admin_instance_arn
  session_duration = "PT8H"
  tags             = {}
}

resource "aws_ssoadmin_managed_policy_attachment" "techops_operator" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.techops_operator.arn
}

resource "aws_ssoadmin_managed_policy_attachment" "techops_operator_support" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AWSSupportAccess"
  permission_set_arn = aws_ssoadmin_permission_set.techops_operator.arn
}

resource "aws_ssoadmin_permission_set_inline_policy" "techops_operator" {
  instance_arn       = local.sso_admin_instance_arn
  inline_policy      = data.aws_iam_policy_document.techops_operator.json
  permission_set_arn = aws_ssoadmin_permission_set.techops_operator.arn
}

data "aws_iam_policy_document" "techops_operator" {
  statement {
    actions = [
      "ec2:CreateSnapshot",
      "ec2:CreateImage",
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:RebootInstances",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceTypes",
      "ec2:GetSerialConsoleAccessStatus",
      "ec2-instance-connect:SendSerialConsoleSSHPublicKey",
      "codepipeline:StartPipelineExecution",
      "codepipeline:StopPipelineExecution",
      "codepipeline:EnableStageTransition",
      "codepipeline:DisableStageTransition",
      "codepipeline:RetryStageExecution",
      "codepipeline:PutApprovalResult",
      "ssm:PutParameter",
      "directconnect:*",
      "ec2:DescribeVpnGateways"
    ]

    resources = ["*"]
  }
}

#########################################
# organisation-security permission sets #
#########################################

# Web Application Firewall (WAF) viewer
#
# This role provides permissions to view:
#
# - Firewall Manager
# - AWS Shield Advanced
resource "aws_ssoadmin_permission_set" "waf_viewer" {
  name             = "web-application-firewall-viewer"
  description      = "A role to view AWS Shield Advanced and Firewall Manager resources"
  instance_arn     = local.sso_admin_instance_arn
  session_duration = "PT8H"
  tags             = {}
}

resource "aws_ssoadmin_managed_policy_attachment" "waf_viewer_firewall_manager" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AWSFMAdminReadOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.waf_viewer.arn
}

resource "aws_ssoadmin_permission_set_inline_policy" "waf_viewer_shield" {
  instance_arn       = local.sso_admin_instance_arn
  inline_policy      = data.aws_iam_policy_document.waf_viewer_shield.json
  permission_set_arn = aws_ssoadmin_permission_set.waf_viewer.arn
}

data "aws_iam_policy_document" "waf_viewer_shield" {
  statement {
    actions = [
      "shield:UntagResource",
      "shield:DescribeProtection",
      "shield:ListResourcesInProtectionGroup",
      "shield:ListTagsForResource",
      "shield:DescribeProtectionGroup",
      "shield:TagResource",
      "shield:DescribeAttack",
      "shield:DescribeAttackStatistics",
      "shield:ListProtectionGroups",
      "shield:DescribeSubscription",
      "shield:GetSubscriptionState",
      "shield:ListProtections",
      "shield:DescribeEmergencyContactSettings",
      "shield:ListAttacks",
      "shield:DescribeDRTAccess"
    ]

    resources = ["*"]
  }
}

#########################################
#   laa landing zone  permission sets   #
#########################################

# S3 Read Access
#
# This role provides read-only access to specific S3 buckets.
resource "aws_ssoadmin_permission_set" "laa_lz_s3_read_access" {
  name             = "laa-lz-s3-read-access"
  description      = "A role that provides read-only access to specific LAA LZ S3 buckets"
  instance_arn     = local.sso_admin_instance_arn
  session_duration = "PT8H"
  tags             = {}
}

resource "aws_ssoadmin_permission_set_inline_policy" "s3_read_access_inline" {
  instance_arn       = local.sso_admin_instance_arn
  inline_policy      = data.aws_iam_policy_document.laa_lz_s3_read_access.json
  permission_set_arn = aws_ssoadmin_permission_set.laa_lz_s3_read_access.arn
}

data "aws_iam_policy_document" "laa_lz_s3_read_access" {
  statement {
    sid = "AllowListAllBucketsForConsole"
    actions = [
      "s3:ListAllMyBuckets"
    ]
    #tfsec:ignore:aws-iam-no-policy-wildcards
    resources = ["*"]
  }
  statement {
    sid = "AllowListAndReadObjects"
    actions = [
      "s3:ListBucketVersions",
      "s3:ListBucket",
      "s3:GetObjectVersion",
      "s3:GetObject",
      "s3:GetBucketLocation",
      "s3:GetBucketObjectLockConfiguration",
      "s3:GetBucketVersioning",
      "s3:GetBucketOwnershipControls"
    ]

    resources = local.laa_lz_data_locations_resources
  }
  statement {
    sid    = "AllowS3DecryptWithCMK"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey"
    ]
    resources = [
      "arn:aws:kms:eu-west-2:${aws_organizations_account.laa_production.id}:alias/s3"
    ]
  }
}


# LAA Security Audit

resource "aws_ssoadmin_permission_set" "laa_security_audit" {
  name             = "LAA SecurityAudit"
  description      = "LAA Security auditor access"
  instance_arn     = local.sso_admin_instance_arn
  session_duration = "PT1H"
  tags             = {}
}

resource "aws_ssoadmin_managed_policy_attachment" "laa_security_audit" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
  permission_set_arn = aws_ssoadmin_permission_set.laa_security_audit.arn
}
resource "aws_ssoadmin_managed_policy_attachment" "laa_security_audit_inspector_v2" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AmazonInspector2ReadOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.laa_security_audit.arn
}

resource "aws_ssoadmin_permission_set_inline_policy" "laa_security_audit_additional" {
  instance_arn       = local.sso_admin_instance_arn
  inline_policy      = data.aws_iam_policy_document.security_audit.json
  permission_set_arn = aws_ssoadmin_permission_set.laa_security_audit.arn
}