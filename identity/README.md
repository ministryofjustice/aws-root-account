# Organisation identity

This Terraform root will manage organisation IAM Identity Center in the
**management account, eu-west-2**. This changes Terraform ownership, not the
AWS account hosting Identity Center.

## Stage 1: prepare dependencies

All Identity Center resources still belong to
[management-account](../management-account). This stage only:

- Publishes the account IDs, account maps, Modernisation Platform OU ID and
  existing SCP alert topic ARN through the
  `identity_center_dependencies` management-account output.
- Adds a read of management-account's S3 state in this root. Consumers of the
  new output will be added when resources move in later stages; there is no
  reference to a potentially unpublished output yet.

No resources move, no imports or removals are needed, and workflows remain
unchanged. Secret values and secret-derived LAA policy resources are not
exported; later consumers can read those directly from Secrets Manager.
As with other Terraform remote-state
consumers, the identity runner needs permission to read the full management
state snapshot, which contains sensitive data.

### Apply and verify

1. Plan management-account and confirm **zero resource additions, changes or
   destroys**; the only planned change should be the new output:

   ```sh
   terraform -chdir=management-account/terraform init
   terraform -chdir=management-account/terraform plan
   terraform -chdir=management-account/terraform apply
   ```

2. Plan identity after the management-account apply. It should only read the
   remote state, with **zero resource additions, changes or destroys**:

   ```sh
   terraform -chdir=identity/terraform init
   terraform -chdir=identity/terraform plan
   terraform -chdir=identity/terraform apply
   ```

3. Review the plan again before approving each apply. Then run
   `terraform plan -detailed-exitcode` in each root and require exit code 0
   (no changes).

No apply freeze is needed for Stage 1. This root can also plan before the new
output is published, because it only reads the existing state snapshot.

## Subsequent stages

Each stage is a separate PR and cutover. Both roots must be usable with clean
plans before starting the next stage.

| Stage | Scope | Ownership transfer |
| --- | --- | --- |
| 2 | Three QuickSight Identity Store groups | Three imports and non-destructive removals |
| 3 | Identity Center administration IAM roles, policies and attachments | Imports and non-destructive removals |
| 4 | Permission sets, attached policies, group lookups and account assignments | Imports and non-destructive removals, preserving assignment keys |
| 5 | GitHub/Entra SCIM, monitoring and periodic-sync resources | Imports where safe; preserve the Chatbot random suffix through a state transfer |
| 6 | Auth0 module and its remaining supporting secrets | Transfer the whole module state to preserve its embedded provider and secrets |

Keep each secret in management-account until its consumers have moved.
Intermediate consumers can read the existing secret by name without taking
ownership. Accounts, OUs, SCPs and SCP alerting remain in management-account.

### Common procedure for later cutovers

1. Prepare a small, reviewed set of imports and source `removed` blocks with
   `destroy = false`. Terraform 1.7 or later is required for these removals.
2. Pause applies to both roots, wait for active state writers to finish, and
   back up both states privately before deploying the ownership change.
3. Apply management-account: **forget only, never destroy**.
4. Apply identity: **import only, never create, update or replace**. Stop if
   import reveals drift or cannot preserve the original resource state.
5. Verify the same resource identities are now owned only by identity, require
   clean plans in both roots, then resume normal automation.

Detailed commands and actual import IDs belong in each stage's PR. Auth0 and
Chatbot state-transfer exceptions need their own reviewed procedure rather
than being mixed into ordinary imports.
