# Note that every AWS account in an AWS organisation _must_ have at least one SCP set.

# This policy is the default set by AWS for every account in an AWS organisation.
# There is a default policy titled "FullAWSAccess" that you can't edit.
# See: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples.html

# Alexa business deny
resource "aws_organizations_policy" "alexa-business-deny" {
  name        = "Alexa business deny"
  description = "Alexa business deny"
  type        = "SERVICE_CONTROL_POLICY"

  content = <<CONTENT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1529493076000",
      "Effect": "Deny",
      "Action": [
        "a4b:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
CONTENT
}

# DenyCloudTrailDeleteStopUpdatePolicy
resource "aws_organizations_policy" "deny-cloudtrail-delete-stop-update-policy" {
  name        = "DenyCloudTrailDeleteStopUpdatePolicy"
  description = "Denies changes to CloudTrail"
  type        = "SERVICE_CONTROL_POLICY"

  content = <<CONTENT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1526482768000",
      "Effect": "Deny",
      "Action": [
        "cloudtrail:DeleteTrail",
        "cloudtrail:StopLogging",
        "cloudtrail:UpdateTrail"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
CONTENT
}
