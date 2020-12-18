# AWS Root Account

This repository holds Terraform for the Ministry of Justice AWS root account.

## AWS Organizations

All accounts defined in here form part of the [AWS Organization](https://aws.amazon.com/organizations/) configuration for the Ministry of Justice, allowing us to use [certain services](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_integrate_services_list.html) for organisational audit, governance, security, and cost optimisation.

## Services

We currently manage:

- [x] [AWS Compute Optimizer](https://docs.aws.amazon.com/compute-optimizer/latest/ug/what-is.html) (not available in Terraform)
- [x] [AWS GuardDuty](https://docs.aws.amazon.com/guardduty/latest/ug/) ([terraform/guardduty.tf](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/guardduty.tf))
- [x] [AWS IAM Access Analyzer (Organisational zone of trust)](https://docs.aws.amazon.com/IAM/latest/UserGuide/access-analyzer-what-is-access-analyzer.html) ([terraform/iam-access-analyzer.tf](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/iam-access-analyzer.tf))
- [x] [AWS Organizations: Service Control Policies](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps.html) ([terraform/organizations-service-control-policies.tf](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/organizations-service-control-policies.tf))
- [x] [AWS Organizations: Tagging Policies](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_tag-policies.html) ([terraform/organizations-tag-policies.tf](https://github.com/ministryofjustice/aws-root-account/blob/main/terraform/organizations-tag-policies.tf))
- [x] [AWS Resource Access Manager (RAM): Organisational sharing](https://docs.aws.amazon.com/ram/latest/userguide/)) (not available in Terraform)
- [x] [AWS S3 Storage Lens](https://docs.aws.amazon.com/AmazonS3/latest/dev/storage_lens_basics_metrics_recommendations.html) (not available in Terraform)
- [x] [AWS Single Sign-On (SSO)](https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html) (not available in Terraform)
- [x] [AWS Trusted Advisor (Organisational overview)](https://docs.aws.amazon.com/organizations/latest/userguide/services-that-can-integrate-ta.html) (not available in Terraform)

In the future, we will also manage:

- [ ] [AWS CloudTrail (Organisational trail)](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html)
- [ ] [AWS Config](https://docs.aws.amazon.com/config/latest/developerguide/WhatIsConfig.html)
- [ ] [AWS Health (Organisational view)](https://docs.aws.amazon.com/health/latest/ug/)
- [ ] [AWS Security Hub](https://docs.aws.amazon.com/securityhub/latest/userguide/)
