# Management account

This directory holds the [Terraform](https://terraform.io) for the MOJ's
[AWS Organizations](https://aws.amazon.com/organizations/) management account.

## SCIM log forwarding

[The SCIM log forwarder](terraform/lambda-scim-log-forwarder.tf) subscribes to
the existing GitHub and Entra ID SCIM CloudWatch log groups. Both jobs continue
logging to CloudWatch with their existing retention and monitoring settings.
Only these two log groups are subscribed; the forwarder's own logs are excluded.

The Python 3.14 ARM64 [handler](terraform/lambda/scim-log-forwarder/handler.py)
uses Powertools for CloudWatch event decoding and structured operational logging.
Terraform packages only the handler, using the pinned AWS-published Powertools
layer; Boto3 comes from the Lambda runtime.

Each data batch produces one gzip-compressed JSON-lines object in the existing
CloudTrail bucket:

```text
AWSLogs/<account-id>/SCIM/YYYY/MM/DD/<batch-sha256>.json.gz
```

The date is the earliest event's UTC date. Each line retains the original message,
CloudWatch event ID, millisecond timestamp, account ID, log group and log stream.
Multiline messages remain a single JSON record with escaped line breaks.
CloudWatch control messages and empty batches produce no objects.

Writes explicitly use the bucket's existing CloudTrail KMS key. The execution
role can write only the SCIM prefix and its failed-invocation prefix; it has no
permission to read log objects or write CloudTrail objects. No bucket lifecycle
or retention settings are changed. SCIM objects contain identifying information,
so access and retention must be agreed before enabling downstream collection.
The forwarder never logs the source event or message contents.

Conditional writes and content-derived keys prevent identical retried batches
from creating additional object versions. Delivery is not exactly-once:
overlapping or differently batched deliveries can repeat event IDs, which a
consumer should use for deduplication.

Lambda retries processing errors twice and retains queued events for up to six
hours. Discarded invocations are sent to the same bucket under
`aws/lambda/async/scim-log-forwarder/`. After fixing the cause, invoke the forwarder
with a failed record's `requestPayload`, not the entire invocation record.
If the bucket or KMS key is unavailable, failure-destination delivery can also
fail; recover from the original CloudWatch logs before their retention expires.
Alarms for errors, throttling and failure-destination delivery use the existing
GitHub SCIM notification topic.

Existing CloudTrail S3 notifications and XSIAM permissions are unchanged.
The CloudTrail collector does **not** collect this new prefix. Configure a
separate generic S3 collector, notification queue and read permissions when
onboarding these logs to XSIAM.

### Validation

From `management-account/terraform`:

```bash
python3.14 -m venv .terraform/scim-log-forwarder-venv
.terraform/scim-log-forwarder-venv/bin/python -m pip install \
  -r lambda/scim-log-forwarder/requirements-test.txt
.terraform/scim-log-forwarder-venv/bin/python -m unittest discover \
  -s lambda/scim-log-forwarder -v
terraform fmt -check lambda-scim-log-forwarder.tf iam-scim-log-forwarder.tf
terraform validate -no-color
```

After deployment, verify that new records from both source log groups remain
visible in CloudWatch and arrive in S3 with the expected messages and metadata.
Check the forwarder's error and failure-destination alarms before declaring
delivery operational.

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
