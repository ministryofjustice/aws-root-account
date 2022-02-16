# AWS Root Account

This repository holds infrastructure as code for the Ministry of Justice
[AWS Organizations](https://aws.amazon.com/organizations/) root account, and
two supporting accounts: organisation-security, and organisation-logging.

## AWS Organizations

All accounts defined here form part of the MOJ's [AWS Organization](https://aws.amazon.com/organizations/),
allowing us to use [certain services](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_integrate_services_list.html)
for organisational audit, governance, security, and cost optimisation.

## Services

| Service | Infrastructure as Code | Managed centrally | Method |
|-|-|-|-|
| [Alternate contact information](https://docs.aws.amazon.com/accounts/latest/reference/API_Operations.html) | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/alternate-contacts.tf) | :wavy_dash: partially (`SECURITY` contact only) | Trusted access |
| [Artifact (security and compliance reports)](https://aws.amazon.com/artifact/) | no | :white_check_mark: yes | no |
| [Audit Manager](https://docs.aws.amazon.com/audit-manager/latest/userguide/what-is.html) | no | :x: no | no |
| [Backup](https://docs.aws.amazon.com/aws-backup/latest/devguide/whatisbackup.html) | no | :x: no | Delegated to teams |
| [CloudFormation Stacksets](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/what-is-cfnstacksets.html) | no | :x: no | no |
| [CloudTrail (Organisational trail)](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html) | no | :x: no | Delegated to teams |
| [CloudWatch Events](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/CloudWatchEvents-CrossAccountEventDelivery.html) | no | :x: no | Delegated to teams |
| [Compute Optimizer](https://docs.aws.amazon.com/compute-optimizer/latest/ug/what-is.html) | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/organizations.tf#L4) | :white_check_mark: yes | Trusted access |
| [Config - Multi-account setup](https://docs.aws.amazon.com/config/latest/developerguide/WhatIsConfig.html) | no | :x: no | Delegated to teams |
| [Config - Multi-region, multi-account aggregation](https://docs.aws.amazon.com/config/latest/developerguide/aggregate-data.html) | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/config-aggregation.tf#L112) | :white_check_mark: yes | Trusted access with a delegated administrator |
| [Control Tower](https://docs.aws.amazon.com/controltower/latest/userguide/organizations.html) | no | :x: no | no |
| [Detective](https://docs.aws.amazon.com/detective/latest/adminguide/what-is-detective.html) | [partially](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/organizations.tf#L6) | :wavy_dash: partially | Trusted access with a delegated administrator |
| [DevOps Guru](https://docs.aws.amazon.com/devops-guru/latest/userguide/getting-started-multi-account.html) | no | :x: no | no |
| [Directory Service](https://docs.aws.amazon.com/directoryservice/latest/admin-guide/what_is.html) | no | :x: no | no |
| [Firewall Manager](https://docs.aws.amazon.com/waf/latest/developerguide/fms-chapter.html) | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/firewall-manager.tf) | :wavy_dash: partially (delegated administrator) | Trusted access with a delegated administrator |
| [GuardDuty](https://docs.aws.amazon.com/guardduty/latest/ug/) | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/guardduty.tf) | :white_check_mark: yes | Trusted access with a delegated administrator |
| [Health (Organisational view)](https://docs.aws.amazon.com/health/latest/ug/) | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/organizations.tf#L8) | :white_check_mark: yes | Trusted access |
| [IAM Access Analyzer (Organisational zone of trust)](https://docs.aws.amazon.com/IAM/latest/UserGuide/access-analyzer-what-is-access-analyzer.html) | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/organizations.tf#L3) | :white_check_mark: yes | Trusted access with a delegated administrator |
| [IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html) | no | :x: no | no |
| [Inspector](https://aws.amazon.com/inspector/) | [partially](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/organizations.tf#L9) | :white_check_mark: yes | Trusted access with a delegated administrator |
| [License Manager](https://docs.aws.amazon.com/license-manager/latest/userguide/license-manager.html) | no | :x: no | no |
| [Macie](https://docs.aws.amazon.com/macie/latest/user/what-is-macie.html) | no | :x: no | no |
| [Marketplace (License management)](https://docs.aws.amazon.com/organizations/latest/userguide/services-that-can-integrate-marketplace.html) | no | :x: no | no |
| [Organizations: AI services opt-out policies](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_ai-opt-out.html) | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/organizations-ai-services-opt-out-policy.tf) | :white_check_mark: yes | [Inheritance](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_inheritance.html) |
| [Organizations: Service Control Policies](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps.html) | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/organizations-service-control-policies.tf) | :white_check_mark: yes | [Inheritance](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_inheritance.html) |
| [Organizations: Tagging policies](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_tag-policies.html) | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/organizations-tag-policies.tf) | :white_check_mark: yes | [Inheritance](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_inheritance.html) |
| [Resource Access Manager (RAM): Organisational sharing](https://docs.aws.amazon.com/ram/latest/userguide/) | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/organizations.tf#L10) | :white_check_mark: yes | Trusted access |
| [S3 Storage Lens](https://docs.aws.amazon.com/AmazonS3/latest/dev/storage_lens_basics_metrics_recommendations.html) | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/organizations.tf#L14) | :white_check_mark: yes | Trusted access |
| [Security Hub](https://docs.aws.amazon.com/securityhub/latest/userguide/) | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/securityhub.tf) | :wavy_dash: partially | Trusted access with a delegated administrator |
| [Service Catalog](https://docs.aws.amazon.com/servicecatalog/latest/adminguide/introduction.html) | no | :x: no | no |
| [Service Quotas](https://docs.aws.amazon.com/servicequotas/latest/userguide/intro.html) | no | :x: no | no |
| [Single Sign-On (SSO)](https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html) | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/sso.tf) | :white_check_mark: yes | Trusted access |
| [Systems Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/Explorer-resource-data-sync.html) | no | :x: no | no |
| [Trusted Advisor (Organisational overview)](https://docs.aws.amazon.com/organizations/latest/userguide/services-that-can-integrate-ta.html) | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/organizations.tf#L11) | :white_check_mark: yes | Trusted access |
| [VPC IP Address Manager (IPAM)](https://docs.aws.amazon.com/vpc/latest/ipam/enable-integ-ipam.html) | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/vpc-ipam.tf) | :white_check_mark: yes | Trusted access with a delegated administrator |
