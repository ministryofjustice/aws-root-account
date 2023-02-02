# AWS Root Account

[![repo standards badge](https://img.shields.io/endpoint?labelColor=231f20&color=005ea5&style=for-the-badge&label=MoJ%20Compliant&url=https%3A%2F%2Foperations-engineering-reports.cloud-platform.service.justice.gov.uk%2Fapi%2Fv1%2Fcompliant_public_repositories%2Fendpoint%2Faws-root-account&logo=data:image/png;base64,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)](https://operations-engineering-reports.cloud-platform.service.justice.gov.uk/public-github-repositories.html#aws-root-account)


This repository holds infrastructure as code for the Ministry of Justice
[AWS Organizations](https://aws.amazon.com/organizations/) root account, and
two supporting accounts: organisation-security, and organisation-logging.

## AWS Organizations

All accounts defined here form part of the MOJ's [AWS Organization](https://aws.amazon.com/organizations/),
allowing us to use [certain services](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_integrate_services_list.html)
for organisational audit, governance, security, and cost optimisation.

## Services

| Service                                                                                                                                             | Infrastructure as Code                                                                                                       | Managed centrally                               | Method                                                                                                          |
| --------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| [Alternate contact information](https://docs.aws.amazon.com/accounts/latest/reference/API_Operations.html)                                          | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/alternate-contacts.tf)                       | :wavy_dash: partially (`SECURITY` contact only) | Trusted access                                                                                                  |
| [Artifact (security and compliance reports)](https://aws.amazon.com/artifact/)                                                                      | no                                                                                                                           | :white_check_mark: yes                          | no                                                                                                              |
| [Audit Manager](https://docs.aws.amazon.com/audit-manager/latest/userguide/what-is.html)                                                            | no                                                                                                                           | :x: no                                          | no                                                                                                              |
| [Backup](https://docs.aws.amazon.com/aws-backup/latest/devguide/whatisbackup.html)                                                                  | no                                                                                                                           | :x: no                                          | Delegated to teams                                                                                              |
| [CloudFormation Stacksets](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/what-is-cfnstacksets.html)                                | no                                                                                                                           | :x: no                                          | no                                                                                                              |
| [CloudTrail (Organisational trail)](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html)                          | no                                                                                                                           | :x: no                                          | Delegated to teams                                                                                              |
| [CloudWatch Events](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/CloudWatchEvents-CrossAccountEventDelivery.html)                     | no                                                                                                                           | :x: no                                          | Delegated to teams                                                                                              |
| [Compute Optimizer](https://docs.aws.amazon.com/compute-optimizer/latest/ug/what-is.html)                                                           | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/organizations.tf#L4)                         | :white_check_mark: yes                          | Trusted access                                                                                                  |
| [Config - Multi-account setup](https://docs.aws.amazon.com/config/latest/developerguide/WhatIsConfig.html)                                          | no                                                                                                                           | :x: no                                          | Delegated to teams                                                                                              |
| [Config - Multi-region, multi-account aggregation](https://docs.aws.amazon.com/config/latest/developerguide/aggregate-data.html)                    | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/config-aggregation.tf#L112)                  | :white_check_mark: yes                          | Trusted access with a delegated administrator                                                                   |
| [Control Tower](https://docs.aws.amazon.com/controltower/latest/userguide/organizations.html)                                                       | no                                                                                                                           | :x: no                                          | no                                                                                                              |
| [Detective](https://docs.aws.amazon.com/detective/latest/adminguide/what-is-detective.html)                                                         | [partially](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/organizations.tf#L6)                   | :wavy_dash: partially                           | Trusted access with a delegated administrator                                                                   |
| [DevOps Guru](https://docs.aws.amazon.com/devops-guru/latest/userguide/getting-started-multi-account.html)                                          | no                                                                                                                           | :x: no                                          | no                                                                                                              |
| [Directory Service](https://docs.aws.amazon.com/directoryservice/latest/admin-guide/what_is.html)                                                   | no                                                                                                                           | :x: no                                          | no                                                                                                              |
| [Firewall Manager](https://docs.aws.amazon.com/waf/latest/developerguide/fms-chapter.html)                                                          | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/firewall-manager.tf)                         | :wavy_dash: partially (delegated administrator) | Trusted access with a delegated administrator                                                                   |
| [GuardDuty](https://docs.aws.amazon.com/guardduty/latest/ug/)                                                                                       | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/guardduty.tf)                                | :white_check_mark: yes                          | Trusted access with a delegated administrator                                                                   |
| [Health (Organisational view)](https://docs.aws.amazon.com/health/latest/ug/)                                                                       | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/organizations.tf#L8)                         | :white_check_mark: yes                          | Trusted access                                                                                                  |
| [IAM Access Analyzer (Organisational zone of trust)](https://docs.aws.amazon.com/IAM/latest/UserGuide/access-analyzer-what-is-access-analyzer.html) | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/organizations.tf#L3)                         | :white_check_mark: yes                          | Trusted access with a delegated administrator                                                                   |
| [IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)                                                                           | no                                                                                                                           | :x: no                                          | no                                                                                                              |
| [Inspector](https://aws.amazon.com/inspector/)                                                                                                      | [partially](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/organizations.tf#L9)                   | :white_check_mark: yes                          | Trusted access with a delegated administrator                                                                   |
| [License Manager](https://docs.aws.amazon.com/license-manager/latest/userguide/license-manager.html)                                                | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/license-manager.tf)                          | :white_check_mark: yes                          | Trusted access with a delegated administrator                                                                   |
| [Macie](https://docs.aws.amazon.com/macie/latest/user/what-is-macie.html)                                                                           | no                                                                                                                           | :x: no                                          | no                                                                                                              |
| [Marketplace (License management)](https://docs.aws.amazon.com/organizations/latest/userguide/services-that-can-integrate-marketplace.html)         | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/organizations.tf)                            | :x: no                                          | Trusted access                                                                                                  |
| [Organizations: AI services opt-out policies](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_ai-opt-out.html)      | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/organizations-ai-services-opt-out-policy.tf) | :white_check_mark: yes                          | [Inheritance](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_inheritance.html) |
| [Organizations: Service Control Policies](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps.html)                | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/organizations-service-control-policies.tf)   | :white_check_mark: yes                          | [Inheritance](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_inheritance.html) |
| [Organizations: Tagging policies](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_tag-policies.html)                | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/organizations-tag-policies.tf)               | :white_check_mark: yes                          | [Inheritance](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_inheritance.html) |
| [Resource Access Manager (RAM): Organisational sharing](https://docs.aws.amazon.com/ram/latest/userguide/)                                          | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/organizations.tf#L10)                        | :white_check_mark: yes                          | Trusted access                                                                                                  |
| [S3 Storage Lens](https://docs.aws.amazon.com/AmazonS3/latest/dev/storage_lens_basics_metrics_recommendations.html)                                 | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/organizations.tf#L14)                        | :white_check_mark: yes                          | Trusted access                                                                                                  |
| [Security Hub](https://docs.aws.amazon.com/securityhub/latest/userguide/)                                                                           | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/securityhub.tf)                              | :wavy_dash: partially                           | Trusted access with a delegated administrator                                                                   |
| [Service Catalog](https://docs.aws.amazon.com/servicecatalog/latest/adminguide/introduction.html)                                                   | no                                                                                                                           | :x: no                                          | no                                                                                                              |
| [Service Quotas](https://docs.aws.amazon.com/servicequotas/latest/userguide/intro.html)                                                             | no                                                                                                                           | :x: no                                          | no                                                                                                              |
| [Single Sign-On (SSO)](https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html)                                                      | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/sso.tf)                                      | :white_check_mark: yes                          | Trusted access                                                                                                  |
| [Systems Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/Explorer-resource-data-sync.html)                                    | no                                                                                                                           | :x: no                                          | no                                                                                                              |
| [Trusted Advisor (Organisational overview)](https://docs.aws.amazon.com/organizations/latest/userguide/services-that-can-integrate-ta.html)         | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/organizations.tf#L11)                        | :white_check_mark: yes                          | Trusted access                                                                                                  |
| [VPC IP Address Manager (IPAM)](https://docs.aws.amazon.com/vpc/latest/ipam/enable-integ-ipam.html)                                                 | [yes](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/vpc-ipam.tf)                                 | :white_check_mark: yes                          | Trusted access with a delegated administrator                                                                   |
