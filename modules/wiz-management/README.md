# Wiz Management-Account Wrapper

This module delegates IAM roles, policies and attachments to the official Wiz
native Terraform module in `vendor/`. It keeps MoJ-specific controls outside the
vendor source:

- A provider account check that must pass before the vendor module is planned.
- Validation of the tenant trust ARN, connector external ID and role path.
- Rejection of EKS scanning with a non-default role path.
- Mapping of the existing wrapper inputs to vendor inputs, including converting
  an optional permissions-boundary policy name to a full ARN.
- Repository role tags and `managed_by = Terraform`; Wiz adds its version tag.
- Tests of wrapper guards, vendor defaults, trust, attachments and policy limits.

The management-account root retains the `wiz_enabled = false` default. Feature
defaults and IAM permissions are unchanged. Customer-managed policy tags now
follow the vendor implementation, which does not set explicit policy tags.

## Reviewed Source

- Archive: <https://wizio-public.s3.amazonaws.com/deployment-v3/aws/terraform/2796/wiz-aws-native-terraform-terraform-module.zip>
- Archive SHA-256: `ada51284d49dd3e6e2f1862385acd725dbadec693335b5af4f458763b21fbd06`
- Vendor version: `2026-10-21`, recorded in `vendor/timestamp.json`.
- Retrieved and reviewed: `2026-10-23`.

All eight archive files are included. Terraform source was normalized with
`terraform fmt`; no other vendor changes were made. The imported files were
compared with an independently formatted extraction of the verified archive.
Git pins the reviewed source; Terraform does not download the ZIP at runtime.

For an update, download the intended archive separately, verify and record its
checksum, extract and format it, review the source diff, then rerun the wrapper
tests and policy comparison. Do not replace vendor source during an apply.

## Verification

From this module directory:

```shell
terraform init -backend=false
terraform validate
terraform test
```

Tests use offline plan operations with dummy credentials and overridden AWS data
lookups, or a mocked provider. They do not create resources. An authenticated
AWS plan and Wiz connector testing are still required before deployment.

## State Compatibility

This replaces the initial, disabled proposal's custom IAM resources with nested
vendor resources. Terraform resource addresses change. There are no automatic
state moves: if the earlier proposal was enabled outside this branch, prepare
and review explicit state moves or imports before applying. Do not allow
same-name roles or policies to be destroyed and recreated as an implicit
migration.