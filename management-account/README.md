# Management account

This directory holds the [Terraform](https://terraform.io) for the MOJ's
[AWS Organizations](https://aws.amazon.com/organizations/) management account.

## Organisation CloudTrail

The organisation-wide CloudTrail trail is configured to pause logging on apply
with `enable_logging = false` in [cloudtrail.tf](terraform/cloudtrail.tf). The
trail and its organisation-security bucket, encryption key, SNS topic and SQS
queue remain in place. While paused, the trail does not deliver new events
to Wiz, and events missed during the pause are not backfilled when it resumes.
Existing logs remain subject to their normal retention policy. The separate
management-account CloudTrail is unaffected.

To resume logging, set `enable_logging = true` on
`aws_cloudtrail.organisation`, review the management-account Terraform plan
and apply it. To pause it again, set it to `false` and apply. Review the plan
before applying to confirm the intended in-place logging change and check for
unrelated changes.

## XSIAM Log Collection

The management account's CloudTrail logs are configured for collection by XSIAM
from the CloudTrail S3 bucket. The GitHub and Entra ID SCIM jobs continue to log
to CloudWatch; their logs are not forwarded to the CloudTrail bucket.

## Wiz CSPM Trial

The Wiz management-account role is created by Wiz's own Terraform module in
[wiz.tf](terraform/wiz.tf). The External ID and trust role ARN are read from the
`wiz_external_id` secret.

## Closing an AWS Account

1. Remove the account and references from code
1. Approve and merge PR, the apply workflow will fail with insufficiant
   permissions
1. Log in as an administrator to the AWS root account
1. Navigate to the Account in AWS Organizations and close the account
1. Re-run the failed workflow
