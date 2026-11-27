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

## IAM-54: direct IAM user policy pilot

`terraform/organizations-policy-iam-user-policies-pilot.tf` defines a separate
SCP attached **only to the sprinkler-development account**, using its account ID
from `local.accounts.active_only`. It does not change the parent MP OU policies
or existing IAM alarms. The pilot policy is included in SCP-change monitoring.

The pilot denies `iam:PutUserPolicy` (creation and updates) and
`iam:AttachUserPolicy` on that account's IAM users, including users with paths.
Existing policies are not removed. Group/role operations, user-policy deletion
and detachment are outside this restriction. This controls direct identity
policies; it is not a complete control over every way users receive permissions.

| Caller in the pilot account | Inline user policy | Managed policy attached to user |
| --- | --- | --- |
| `ModernisationPlatformAccess` | Exempt | Exempt |
| `MemberInfrastructureAccess` | Exempt | Exempt |
| `github-actions` | Exempt | Exempt |
| `github-actions-apply` | Exempt | Exempt |
| `credential-responder-lambda` | Exempt for quarantine | Denied |
| Other callers, including direct SSO administrator sessions | Denied | Denied |

Exceptions use exact account-qualified IAM role ARNs, not session names or
resource tags. Exempt means this SCP does not deny the operation, not that it
grants access. Other policies still apply. Provisioning exceptions intentionally
cover all user targets in this pilot, including authorised MP administration via
`MemberInfrastructureAccess`. An administrator able to assume an exempt role
can therefore perform these operations through it. Protect the exempt roles,
their trust policies and the automation/Lambda code. IAM has no condition key
to limit `PutUserPolicy` to the `EmergencyQuarantine` policy name or deny-only
documents: the responder's inline exception is necessarily broader than that
single document. Do not copy general administrator or Cloud Platform alarm
exceptions into this pilot without a demonstrated requirement.

Existing baseline detection remains unchanged. It excludes approved automation
and suppresses notifications in Sprinkler, so **a denied pilot request is not
expected to send the existing IAM alarm to Slack**. Verify the denial through
CloudTrail. SCP-change monitoring is a separate notification path. Existing
alarm testing is not evidence that this new preventive control works.

### Validation and rollout

Run `python3 -m unittest discover -s management-account/tests` from the repository
root. These offline tests render the actual Terraform locals with a synthetic
account ID and check the policy's restricted action/resource/exception subset.
They do not simulate AWS's complete authorization engine or prove deployment.
Run Terraform formatting/validation and review the management-account CI plan.

Before applying, check live account SCP attachment capacity and effective parent
policies. The intended plan adds one SCP and one account attachment and updates
the existing SCP-change EventBridge pattern. Investigate unrelated changes.

After an approved pilot apply, use disposable users without login profiles or
access keys and a harmless explicit-deny policy. Record:

- Both operations denied for a non-exempt caller (including a user with a path).
- Both operations permitted by this SCP for approved provisioning/administration.
- Quarantine inline writes preserved; responder managed attachments still denied.
- Group/role policy management and cleanup unaffected.
- CloudTrail events and completed Terraform provisioning, including role assumption
  via the actual Sprinkler workflow. Do not trigger a real credential incident.

Remove test policies/users and retain redacted results. If access is disrupted,
detach the **pilot** policy through the management account's approved process;
reconcile Terraform afterwards. Do not change unrelated parent protections.
No broader enforcement is authorised by this pilot: promote only after reviewing
results, account-specific role paths/exceptions, attachment capacity and rollout
scope. Member-unrestricted production scope remains deferred. Sandbox alarm
suppression does not automatically exempt an account from prevention.

## Closing an AWS Account

1. Remove the account and references from code
1. Approve and merge PR, the apply workflow will fail with insufficiant
   permissions
1. Log in as an administrator to the AWS root account
1. Navigate to the Account in AWS Organizations and close the account
1. Re-run the failed workflow
