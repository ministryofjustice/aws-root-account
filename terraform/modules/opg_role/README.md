# OPG Role

Creates an IAM role that can be assumed by AWS IAM Users

## Requirements

| Name      | Version   |
|-----------|-----------|
| terraform | >= 0.13.0 |
| aws       | >= 2.70   |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | name for the IAM role | `string` | `` | yes |
| user\_arns | List of IAM user ARNs | `list` | `[]` | yes |
| base\_policy\_arn | Base policy to give the role | `string` | `arn:aws:iam::aws:policy/ReadOnlyAccess` | no |
| custom\_policy\_json | Custom policy to apply to the role | `json` | `` | no |
