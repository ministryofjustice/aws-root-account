# Wiz Management-Account Wrapper

This module delegates IAM roles, policies and attachments to the official Wiz
native Terraform module downloaded from the archive below. It keeps MoJ-specific
controls outside the vendor source:

- A provider account check that must pass before the vendor module is planned.
- Validation of the tenant trust ARN, connector external ID and role path.
- Rejection of EKS scanning with a non-default role path.
- Mapping of the existing wrapper inputs to vendor inputs, including converting
  an optional permissions-boundary policy name to a full ARN.
- Repository role tags and `managed_by = Terraform`; Wiz adds its version tag.
- Tests of wrapper guards and vendor feature defaults, with default and
  all-enabled plans.

The management-account root retains the `wiz_enabled = false` default. Feature
defaults and IAM permissions are unchanged. Customer-managed policy tags now
follow the vendor implementation, which does not set explicit policy tags.

## Reviewed Source

- Archive:
  <https://wizio-public.s3.amazonaws.com/deployment-v3/aws/terraform/2796/wiz-aws-native-terraform-terraform-module.zip>
- Archive SHA-256:
  `ada51284d49dd3e6e2f1862385acd725dbadec693335b5af4f458763b21fbd06`
- Vendor version: `2026-10-21`, recorded in the archive's `timestamp.json`.
- Retrieved and reviewed: `2026-10-23`.

Terraform downloads the official ZIP directly during `terraform init`. No vendor
source is copied or modified in this repository. The URL selects archive 2796;
Terraform's dependency lockfile does not lock or verify module archive
checksums. The checksum above records the source reviewed, not an enforced
installation check. If Wiz replaces that URL's contents, initialization can
obtain different code.

For an update, verify and record the intended archive checksum, review its
source and policy changes, update the URL, then rerun the wrapper tests and
approved plan.

## Management Deployment and Delegation

This proposal manages only the management-account role. AWS excludes the
management account from service-managed StackSets. Member-account deployment
from organisation-security is a separate proposal; this module does not deploy
to member accounts or create a connector in Wiz.

StackSets trusted access and delegation to organisation-security already exist
in [organizations.tf](../../management-account/terraform/organizations.tf):
`member.org.stacksets.cloudformation.amazonaws.com` is an enabled service
principal, and
`aws_organizations_delegated_administrator.stacksets_organisation_security`
delegates administration to the existing organisation-security account. No
duplicate delegation resource or additional service delegation is needed for
this proposal.

Vendor defaults enable cloud cost, RDS logs, S3 AWSLogs, S3 KMS decrypt and
Terraform-bucket scanning. Data, EKS, Lightsail and S3 inventory scanning
default to disabled. This is **not read-only access**: baseline permissions
include snapshot/volume creation, snapshot sharing and KMS operations. Logs and
Terraform state can contain sensitive data. Review these permissions before
enabling.

Before deployment, confirm the native role and connector discovery with Wiz,
inventory existing Wiz roles/policies, and reconcile ownership of same-name
resources. Obtain the tenant trust role ARN and connector external ID from Wiz.
The external ID is sensitive but remains in Terraform state and IAM trust
policies. Supply these settings through the management root's normal deployment
environment:

```hcl
wiz_enabled        = true
wiz_trust_role_arn = "<Wiz tenant trust role ARN>"
wiz_external_id    = "<Wiz connector external ID>"
```

These documentation placeholders are not valid inputs. Current workflows do not
supply these settings, so the proposal remains disabled. Review an authenticated
AWS plan and obtain approval before applying, then test connector role
assumption. Setting `wiz_enabled` back to false after deployment destroys the
role and policies; it does not pause scanning.

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
