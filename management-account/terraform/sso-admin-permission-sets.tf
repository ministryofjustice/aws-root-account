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

# Billing Access
resource "aws_ssoadmin_permission_set" "billing" {
  name             = "Billing"
  description      = "Billing-only access"
  instance_arn     = local.sso_admin_instance_arn
  session_duration = "PT8H"
  tags             = {}
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

# Modernisation Platform developer
resource "aws_ssoadmin_permission_set" "modernisation_platform_developer" {
  name             = "modernisation-platform-developer"
  description      = "Modernisation Platform: developer tenancy"
  instance_arn     = local.sso_admin_instance_arn
  session_duration = "PT8H"
  tags             = {}
}

resource "aws_ssoadmin_managed_policy_attachment" "modernisation_platform_developer" {
  instance_arn       = local.sso_admin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.modernisation_platform_developer.arn
}

resource "aws_ssoadmin_permission_set_inline_policy" "modernisation_platform_developer" {
  instance_arn       = local.sso_admin_instance_arn
  inline_policy      = data.aws_iam_policy_document.modernisation_platform_developer.json
  permission_set_arn = aws_ssoadmin_permission_set.modernisation_platform_developer.arn
}

data "aws_iam_policy_document" "modernisation_platform_developer" {
  statement {
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
      "secretsmanager:PutSecretValue",
      "secretsmanager:UpdateSecret",
      "secretsmanager:RestoreSecret",
      "ssm:*",
      "kms:Decrypt*",
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:RebootInstances",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "sns:Publish"
    ]

    resources = ["arn:aws:sns:*:*:Automation*"]
  }

  statement {
    actions = [
      "lambda:InvokeFunction"
    ]

    resources = ["arn:aws:lambda:*:*:function:Automation*"]
  }


  statement {
    actions = [
      "iam:CreateAccessKey",
      "iam:DeleteAccessKey",
      "iam:GetAccessKeyLastUsed",
      "iam:GetUser",
      "iam:ListAccessKeys",
      "iam:UpdateAccessKey"
    ]

    resources = ["arn:aws:iam::*:user/cicd-member-user"]
  }

  statement {
    actions = [
      "sts:AssumeRole"
    ]

    resources = [
      "arn:aws:iam::*:role/read-dns-records",
      "arn:aws:iam::*:role/member-delegation-read-only",
      "arn:aws:iam::${local.modernisation_platform_environment_management["core-shared-services-production"]}:role/member-shared-services"
    ]
  }
}

# Modernisation Platform engineer
# This role is designed to be used as an alternative to a full on admin role / read only role when trouble shooting MP accounts
# Currently this is just readonly plus the ability to create support tickets, but potential we could add more permissions in here if it reduces admin role or superadmin usage
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
}

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
    sid    = "ViewBillingInfo"
    effect = "Allow"

    actions = [
      "aws-portal:*",
      "budget:*",
      "cur:*",
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
      "dynamodb:*List*",
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
  managed_policy_arn = "arn:aws:iam::aws:policy/AWSCloudTrailReadOnlyAccess"
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
      "codepipeline:StartPipelineExecution",
      "codepipeline:StopPipelineExecution",
      "codepipeline:EnableStageTransition",
      "codepipeline:DisableStageTransition",
      "codepipeline:RetryStageExecution",
      "codepipeline:PutApprovalResult",
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
