# Management account

This directory holds the [Terraform](https://terraform.io) for the MOJ's
[AWS Organizations](https://aws.amazon.com/organizations/) management account.

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
