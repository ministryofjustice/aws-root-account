# Wiz CSPM Trial

The member-account trial is **disabled by default**. No Wiz
resources are created until `wiz_enabled = true` is explicitly supplied to the
relevant root. The member-account target is deliberately `placeholder OU`, not
an existing MoJ OU. Enabling the StackSet with this placeholder fails validation.

## Deployment Split

- `organisation-security/terraform/wiz.tf` calls this module through the existing
  delegated-administrator provider. CloudFormation owns IAM resources in the
  targeted member accounts, including descendant OUs and future accounts entering
  scope. Deployment uses one region, `eu-west-2`, because IAM is global.
- AWS excludes the management account from service-managed StackSets. Its native
   Terraform deployment is a separate proposal; this module does not create
   management-account resources and can be reviewed independently.
- StackSets trusted access and delegated administration are already configured
  in `management-account/terraform/organizations.tf`; this trial does not change
  those settings or create a connector in Wiz.

## Vendor Defaults

The member-account StackSet uses Wiz's `2026-10-21` standard AWS template:
<https://wizio-public.s3.amazonaws.com/deployment-v2/aws/wiz-aws-standard.json>.
The downloaded source SHA-256 is
`4081ebae61dafe47db0f312d0681f6f95b71343038c8637277b35d41756f1ae7`.
The template is embedded locally; Terraform does not fetch it at deployment time.
Updates require a new source comparison and policy review.

This module retains the supplied vendor feature defaults:

| Feature | Default |
| --- | --- |
| Cloud cost scanning | Enabled |
| RDS log scanning | Enabled |
| S3 AWSLogs scanning | Enabled |
| S3 KMS decrypt | Enabled |
| Terraform-bucket scanning | Enabled |
| Data scanning | Disabled |
| EKS scanning | Disabled |
| Lightsail scanning | Disabled |
| S3 inventory scanning | Disabled |

This is **not a read-only/configuration-only role**. The baseline policy also
permits snapshot/volume creation, snapshot sharing and KMS operations, even when
optional data scanning is disabled. Terraform-bucket access can expose state
containing credentials and other sensitive values. Review this access in every
account in the intended trial OU.

Trial rollout deliberately differs from the supplied 50/50 settings: zero account
failures are tolerated and at most one account is processed at a time. Both
StackSet updates and target deployment use absolute counts, not percentages.
Vendor scanning features and IAM permissions remain unchanged. Inspect every
stack instance rather than treating a StackSet ID as evidence of success;
stopping on a failure does not roll back accounts already deployed successfully.

Both retention flags default to false. Accounts leaving scope lose their member
stacks, and destroying the Terraform deployment target deletes the member stacks.
Changing `wiz_enabled` back to false after deployment is a destroy operation,
not a pause in scanning. Changing retention requires an explicit module argument
and a review of the unmanaged access that would remain.

## Before Enabling

1. Confirm with Wiz that this tenant supports direct service-managed StackSets
   without its outer organization stack. Organization connector discovery
   and any updater behavior still need vendor confirmation.
2. Inventory existing `WizAccess-Role` roles, `Wiz*Policy` policies and Wiz stacks
   in every intended account. Reconcile ownership before deploying same-name
   resources; this code does not import or migrate existing resources.
3. Obtain the tenant/data-centre trust role ARN and connector external ID from
   Wiz. Neither is the MoJ deployment role. The external ID is marked sensitive,
   but is still stored in Terraform state and IAM trust policies.
4. Replace `placeholder OU` with the approved trial OU ID. Descendant accounts
   are included automatically. Do not substitute the organization root without
   approval for organization-wide access.
5. Supply the inputs through the normal deployment environment and review the
   organisation-security plan. Current workflows do not supply these inputs,
   so scheduled plans and existing CI runs leave the trial disabled.
6. Apply only after approval, then verify each member stack and test the Wiz
   connector's member-account discovery and role assumption.

For the organisation-security root, supply:

```hcl
wiz_enabled        = true
wiz_trust_role_arn = "<Wiz tenant trust role ARN>"
wiz_external_id    = "<Wiz connector external ID>"
wiz_target_ou_ids = ["<approved trial OU ID>"]
```

The angle-bracket values above are documentation placeholders, not valid inputs.
Use the matching external ID for the connector associated with each deployment.

## Local Verification

From this module directory, using Terraform 1.7 or later for test support:

```shell
terraform init -backend=false
terraform validate
terraform test
```

Tests cover vendor feature defaults, trust restrictions, deployment targeting,
rollout settings and invalid placeholder/reserved inputs. Tests use a mocked AWS
provider. They do not create resources or require AWS credentials.

The embedded member template was compared structurally with the source above and
renders to 39,336 bytes, below the 51,200-byte inline limit. An isolated root-wrapper
plan confirms that the default-disabled integration does not instantiate the Wiz
module.

Local validation is not a substitute for an authenticated AWS plan, IAM-policy
review, successful StackSet operations, or a working Wiz connector.