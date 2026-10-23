<!-- BEGIN_TF_DOCS -->
# wiz-aws-native-terraform #

A Terraform module to create an AWS connector with Wiz.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.wiz_cloud_cost_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.wiz_defend_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.wiz_full_policy2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.wiz_full_policy3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.wiz_full_policy4](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.wiz_lightsail_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.wiz_policy_data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.wiz_terraform_scanning_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.user-role-tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.wiz_full_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.wiz_policy_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.security_audit_role_policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.view_only_access_role_policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.wiz_cloud_cost_policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.wiz_data_scanning_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.wiz_defend_policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.wiz_full_policy2_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.wiz_full_policy3_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.wiz_full_policy4_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.wiz_lightsail_scanning_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.wiz_terraform_scanning_policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy.security_audit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.view_only_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_external-id"></a> [external-id](#input\_external-id) | Connector External ID | `string` | n/a | yes |
| <a name="input_cloud-cost-scanning"></a> [cloud-cost-scanning](#input\_cloud-cost-scanning) | Enable Cloud Cost scanning | `bool` | `true` | no |
| <a name="input_data-scanning"></a> [data-scanning](#input\_data-scanning) | Enable DSPM data scanning | `bool` | `false` | no |
| <a name="input_eks-scanning"></a> [eks-scanning](#input\_eks-scanning) | Enable EKS scanning | `bool` | `false` | no |
| <a name="input_iam_policy_suffix"></a> [iam\_policy\_suffix](#input\_iam\_policy\_suffix) | (Optional) suffix for the policy name | `string` | `""` | no |
| <a name="input_lightsail-scanning"></a> [lightsail-scanning](#input\_lightsail-scanning) | Enable Lightsail scanning | `bool` | `false` | no |
| <a name="input_permission_boundary_arn"></a> [permission\_boundary\_arn](#input\_permission\_boundary\_arn) | Optional - ARN of the policy that is used to set the permissions boundary for the role. | `string` | `null` | no |
| <a name="input_remote-arn"></a> [remote-arn](#input\_remote-arn) | Enter the AWS Trust Policy Role ARN for your Wiz data center. You can retrieve it from User Settings, Tenant in the Wiz portal | `string` | `""` | no |
| <a name="input_role_path"></a> [role\_path](#input\_role\_path) | The path for the IAM role. Useful for organizing roles under a specific path (e.g., /governance/). | `string` | `"/"` | no |
| <a name="input_rolename"></a> [rolename](#input\_rolename) | Enter the IAM role name that will be created in your AWS account, the default is WizAccess-Role | `string` | `"WizAccess-Role"` | no |
| <a name="input_s3-inventory-scanning"></a> [s3-inventory-scanning](#input\_s3-inventory-scanning) | Enable S3 Inventory Scanning. Disabled by default. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_terraform-bucket-scanning"></a> [terraform-bucket-scanning](#input\_terraform-bucket-scanning) | Enable Terraform Bucket scanning | `bool` | `true` | no |
| <a name="input_wiz-defend-awslogs-policy"></a> [wiz-defend-awslogs-policy](#input\_wiz-defend-awslogs-policy) | (Optional) Enable Wiz Defend AWS Logs policy | `bool` | `true` | no |
| <a name="input_wiz-defend-rds-policy"></a> [wiz-defend-rds-policy](#input\_wiz-defend-rds-policy) | (Optional) Enable Wiz Defend RDS policy | `bool` | `true` | no |
| <a name="input_wiz-defend-s3-kms-policy"></a> [wiz-defend-s3-kms-policy](#input\_wiz-defend-s3-kms-policy) | (Optional) Enable Wiz Defend S3 KMS policy | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | Wiz Access Role ARN |
| <a name="output_wiz_last_updated"></a> [wiz\_last\_updated](#output\_wiz\_last\_updated) | Wiz Version Last Updated Timestamp |
<!-- END_TF_DOCS -->