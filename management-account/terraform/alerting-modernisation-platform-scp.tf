###############################################################
# Alerting: Modernisation Platform SCP changes
###############################################################

resource "aws_sns_topic" "modernisation_platform_scp_change_alerts" {
  provider = aws.us-east-1

  name = "modernisation-platform-scp-change-alerts"

  tags = {
    business-unit = "Platforms"
    component     = "SNS_TOPIC"
    source-code   = join("", [local.github_repository, "/terraform/alerting-modernisation-platform-scp.tf"])
  }
}

resource "aws_cloudwatch_event_rule" "modernisation_platform_scp_change_alerts" {
  provider = aws.us-east-1

  name        = "modernisation-platform-scp-change-alerts"
  description = "Alerts on AWS Organizations changes to Modernisation Platform SCPs."

  event_pattern = jsonencode({
    "detail-type" = ["AWS API Call via CloudTrail"]
    "source"      = ["aws.organizations"]
    "detail" = {
      "eventSource" = ["organizations.amazonaws.com"]
      "eventName" = [
        "UpdatePolicy",
        "AttachPolicy",
        "DetachPolicy",
        "DeletePolicy"
      ]
      "requestParameters" = {
        "policyId" = [
          aws_organizations_policy.rds_guardrails.id,
          aws_organizations_policy.mp_deny_cloudtrail_delete_stop_update.id,
          aws_organizations_policy.mp_protect_core_s3_buckets.id,
          aws_organizations_policy.modernisation_platform_member_ou_scp.id,
          aws_organizations_policy.mp_protect_secure_baselines.id
        ]
      }
    }
  })

  tags = {
    business-unit = "Platforms"
    component     = "EVENTBRIDGE_RULE"
    source-code   = join("", [local.github_repository, "/terraform/alerting-modernisation-platform-scp.tf"])
  }
}

resource "aws_cloudwatch_event_target" "modernisation_platform_scp_change_alerts" {
  provider = aws.us-east-1

  rule = aws_cloudwatch_event_rule.modernisation_platform_scp_change_alerts.name
  arn  = aws_sns_topic.modernisation_platform_scp_change_alerts.arn
}

data "aws_iam_policy_document" "modernisation_platform_scp_change_alerts_topic_policy" {
  statement {
    sid    = "AllowEventBridgePublish"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions = [
      "sns:Publish"
    ]

    resources = [
      aws_sns_topic.modernisation_platform_scp_change_alerts.arn
    ]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values = [
        aws_cloudwatch_event_rule.modernisation_platform_scp_change_alerts.arn
      ]
    }
  }
}

resource "aws_sns_topic_policy" "modernisation_platform_scp_change_alerts" {
  provider = aws.us-east-1

  arn    = aws_sns_topic.modernisation_platform_scp_change_alerts.arn
  policy = data.aws_iam_policy_document.modernisation_platform_scp_change_alerts_topic_policy.json
}
