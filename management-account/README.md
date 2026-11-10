# Management account

This directory holds the [Terraform](https://terraform.io) for the MOJ's
[AWS Organizations](https://aws.amazon.com/organizations/) management account.

## XSIAM Log Collection

The management account's CloudTrail logs are configured for collection by XSIAM
from the CloudTrail S3 bucket. CloudTrail redacts some Identity Center user and
group details, so the [SCIM log forwarder](terraform/lambda-scim-log-forwarder.tf)
also copies the GitHub and Entra ID SCIM jobs' CloudWatch logs to the bucket:

- `SCIM/aws-sso-scim-github/AWSLogs/<account-id>/`
- `SCIM/entra-id-scim-lambda/AWSLogs/<account-id>/`

The jobs continue to log to CloudWatch. SCIM logs are gzip-compressed JSON lines
and can contain identifying information. XSIAM's existing CloudTrail collector
does not collect them; a separate S3 collector, notifications, and read and
decrypt permissions are needed.

The forwarder's own logs, including delivery errors, go to CloudWatch only.
Lambda retries function errors twice, but there is no separate failed-invocation
destination. After retries or event expiry, failed batches are discarded; the
original SCIM logs remain in CloudWatch until their retention expires and are
not automatically replayed. S3 writes remain limited to the two SCIM prefixes.

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
