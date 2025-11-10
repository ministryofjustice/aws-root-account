# AWS Root Account

[![MoJ Repository Standards](https://github-community.service.justice.gov.uk/repository-standards/api/aws-root-account/badge)](https://github-community.service.justice.gov.uk/repository-standards/aws-root-account)

This repository defines and manages the MoJ AWS Management Account, which serves as the **root of the MoJ AWS Organization**.
It provides shared services, centralized governance, and foundational security for all AWS accounts under the Ministry of Justice.

This repository manages the following AWS accounts:

- The Management Account (`MoJ Master` also referred to as `AWS Root Account`)
- Supporting organizational accounts (`organisation-security`, `organisation-logging (to be added)`)
- Lifecycle management of accounts that are not provided by the Modernisation Platform

This repository also manages the following services:

- SSO Access to AWS Accounts and Applications through GitHub and Microsoft Justice Identities
- Opt-in Extended Detection and Response (XDR) AWS Account Integration with MoJ Security Operations Centre (SOC)
- Automatically setting the Security Contact of all Member Accounts to `security@justice.gov.uk`
- Configuring AWS Organization such as creating Organizational Units, AWS Accounts, Service Control Policies. For details on all AWS Organization integrated services, see [AWS Organizations Integrated Services Overview](#️-aws-organizations-integrated-services-overview)

## 🧭 Repository Structure Overview

```sh
.
├── .github/                            # Issue templates, workflows (CI/CD), CODEOWNERS, etc.
├── management-account/                 # IaC for Managment Account. Contains configuration Organisations, Identity Centre, Cost and Billing etc.
├── modules/                            # Reusable Terraform modules for creating common AWS resources
├── organisation-security/              # IaC for Organisation Security Account. Contains configuration for GuardDuty, SecurityHub etc.
└── scripts/                            # Utility scripts for managing AWS Organization
```

## 👥 Ownership & Support

| Responsibility                          | Team / Role                                                                                                                         | Contact                                                                                            |
| --------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| Primary ownership of `aws-root-account` | [Hosting Tech Leads](https://github.com/orgs/ministryofjustice/teams/hosting-tech-leads)                                            | [#aws-root-account](https://moj.enterprise.slack.com/archives/C06P4KA0V0A)                         |
| Strategic MoJ AWS landing zone          | [Modernisation Platform](https://github.com/orgs/ministryofjustice/teams/modernisation-platform)                                    | [#ask-modernisation-platform](https://moj.enterprise.slack.com/archives/C013RM6MFFW)               |
| AWS cost and billing                    | [Cloud Optimisation and Accountability Team](https://github.com/orgs/ministryofjustice/teams/cloud-optimisation-and-accountability) | [#cloud-optimisation-and-accountability-team](https://moj.enterprise.slack.com/archives/CPVD6398C) |
| Security consultation and reviews       | P&A Cyber Security                                                                                                                  | [#ask-panda-cyber](https://moj.enterprise.slack.com/archives/C0476G42C0N)                          |
| Ownership of overall AWS Service        | Hosting                                                                                                                             | [#hosting](https://moj.enterprise.slack.com/archives/CA454PY2C)                                    |

## ☁️ AWS Organizations Integrated Services Overview

The Ministry of Justice AWS Organization integrates with a number of [AWS services that work with Organizations](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_integrate_services_list.html), enabling centralized governance, security, and automation across all member accounts.

This section lists **all AWS services known to support integration with AWS Organizations**, showing which are **enabled** for the MoJ Organization.

Each service is grouped by category and includes:

- **Status**: Whether it’s currently enabled in the Organization.
- **Description**: Summary of the service’s org-level integration.
- **Managed By**: Which account or repository owns the service configuration.
- **Rationale**: Why it is (or isn’t) enabled.

<details>
<summary>🛡️ Security & Compliance Services</summary>

The following AWS Services establish organization-wide visibility, detection, and enforcement of security posture.

| Status | Service                                                   | Description                                                                             | Managed By              | Rationale                                                                                             |
| :----: | :-------------------------------------------------------- | :-------------------------------------------------------------------------------------- | :---------------------- | :---------------------------------------------------------------------------------------------------- |
|   ✅   | **Detective** (`detective.amazonaws.com`)                 | Security investigation service that builds relationship graphs from GuardDuty findings. | `organisation-security` | Provides org-wide threat investigation capability.                                                    |
|   ✅   | **Firewall Manager** (`fms.amazonaws.com`)                | Central policy management for WAF, Shield, and security groups.                         | `MoJ Master`            | Enforces baseline network security policies, such as auto attachting basic firewalls to applications. |
|   ✅   | **GuardDuty** (`guardduty.amazonaws.com`)                 | Threat detection and monitoring across accounts.                                        | `organisation-security` | Centralised GuardDuty delegated admin for all accounts.                                               |
|   ✅   | **IAM Access Analyzer** (`access-analyzer.amazonaws.com`) | Enables org-wide IAM Access Analyzer for external access findings.                      | `organisation-security` | Provides org-level visibility into cross-account access.                                              |
|   ✅   | **Inspector** (`inspector2.amazonaws.com`)                | Automated vulnerability scanning across instances, containers, and Lambda.              | `organisation-security` | Ensures continuous compliance scanning across org.                                                    |
|   ✅   | **Macie** (`macie.amazonaws.com`)                         | Data classification and discovery for sensitive data in S3.                             | `organisation-security` | Enforces data governance and DLP across S3.                                                           |
|   ✅   | **Security Hub** (`securityhub.amazonaws.com`)            | Centralized security findings aggregator.                                               | `organisation-security` | Centrlised SecurityHub Aggregates for easier integration with SOC.                                    |

</details>

<details>
<summary>⚖️ Governance & Access Control</summary>

The following AWS Services define organizational structure, manage policies and permissions, and orchestrate account lifecycle.

| Status | Service                                            | Description                                                                 | Managed By              | Rationale                                                           |
| :----: | :------------------------------------------------- | :-------------------------------------------------------------------------- | :---------------------- | :------------------------------------------------------------------ |
|   ✅   | **Account Management** (`account.amazonaws.com`)   | Enables API-level management of AWS accounts within the organization.       | `MoJ Master`            | Required for account provisioning and lifecycle management.         |
|   ✅   | CloudFormation Stacksets                           | Provision infrastructure in all member accounts.                            | `organisation-security` | Organisation-wide governance and integreations, such as with XSIAM  |
|   ✅   | **IAM** (`iam.amazonaws.com`)                      | Organization-wide identity service integration (for Access Analyzer, SCPs). | `MoJ Master`            | Required for managing root users, setting SCPs and access analyzer. |
|   ✅   | **Resource Access Manager** (`ram.amazonaws.com`)  | Share specified AWS resources that you own with other AWS accounts.         | `MoJ Master`            | Enables easier cross account resource access within org.            |
|   ✅   | **IAM Identity Center** (`sso.amazonaws.com`)      | Enable visibility and control of your AWS resources.                        | `MoJ Master`            | Allows central SSO service for AWS Access via GitHub and Microsoft. |
|   ✅   | **Tag Policies** (`tagpolicies.tag.amazonaws.com`) | Standardise tags across resources in your organization's accounts.          | `MoJ Master`            | Define standardised tagging rules for resources.                    |

</details>

<details>
<summary>⚙️ Operations & Resilience</summary>

The following AWS Services enable cross-account operational monitoring, automation, and recovery.

| Status | Service                                               | Description                                                           | Managed By              | Rationale                                                      |
| :----: | :---------------------------------------------------- | :-------------------------------------------------------------------- | :---------------------- | :------------------------------------------------------------- |
|   ✅   | **AWS Backup** (`backup.amazonaws.com`)               | Centralized backup plans and compliance management across accounts.   | `MoJ Master`            | Currently, only monitors backups across the organisation.      |
|   ✅   | **AWS Config** (`config.amazonaws.com`)               | Tracks configuration changes and compliance across accounts.          | `organisation-security` | Enables centralized config aggregators and conformance packs.  |
|   ✅   | **AWS Health** (`health.amazonaws.com`)               | Aggregates AWS Health events across the organization.                 | `MoJ Master`            | Allows central visibility of incidents and maintenance events. |
|   ✅   | **License Manager** (`license-manager.amazonaws.com`) | Tracks and enforces software license usage across accounts.           | `organisation-security` | Used to manage enterprise licensing across org.                |
|   ✅   | **IP Address Manager (IPAM)** (`ipam.amazonaws.com`)  | Enables central management of IP address allocations across accounts. | `organisation-security` | Supports CIDR allocation and VPC IP tracking.                  |

</details>

<details>
<summary>💰 Cost Management & Optimization</summary>

The following AWS Services provide consolidated visibility and optimization of spend, usage, and cost allocation.

| Status | Service                                                                   | Description                                                                                                                                   | Managed By   | Rationale                                              |
| :----: | :------------------------------------------------------------------------ | :-------------------------------------------------------------------------------------------------------------------------------------------- | :----------- | :----------------------------------------------------- |
|   ✅   | **Billing and Cost Management** (`billing-cost-management.amazonaws.com`) | Enables consolidated billing and budgets across the organization.                                                                             | `MoJ Master` | Required for consolidated billing and cost allocation. |
|   ✅   | **Compute Optimizer** (`compute-optimizer.amazonaws.com`)                 | Provides org-wide optimization recommendations for compute resources.                                                                         | `MoJ Master` | Helps identify cost-saving opportunities.              |
|   ✅   | **Cost Optimization Hub** (`cost-optimization-hub.bcm.amazonaws.com`)     | Aggregates cost optimization insights across accounts.                                                                                        | `MoJ Master` | Centralizes cost optimization insights.                |
|   ✅   | **Marketplace** (`license-management.marketplace.amazonaws.com`)          | curated digital catalog that you can use to find, buy, deploy, and manage third-party software.                                               | `MoJ Master` | Centrally manage purchases through AWS Marketplace.    |
|   ✅   | **S3 Storage Lens** (`storage-lens.s3.amazonaws.com`)                     | S3 storage usage and activity metrics with actionable recommendations to optimize storage.                                                    | `MoJ Master` | Centralizes cost optimization insights.                |
|   ✅   | **Trusted Advisor** (`reporting.trustedadvisor.amazonaws.com`)            | makes recommendations when opportunities exist to save money, to improve system availability and performance, or to help close security gaps. | `MoJ Master` | Centralizes cost optimization and security insights.   |

</details>

<details>
<summary>💤 Services Not Yet Enabled</summary>

These services support AWS Organizations integration but are currently **disabled** in the MoJ Organization.

| Status | Service                                                                                             | Description                                                                                             | Rationale |
| :----: | :-------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------ | :-------- |
|   ❌   | **Application Migration Service** (`mgn.amazonaws.com`)                                             | Manage large-scale migrations across multiple accounts                                                  | -         |
|   ❌   | **AWS Artifact** (`mgn.amazonaws.com`)                                                              | accept agreements on behalf of all accounts within your organization.                                   | -         |
|   ❌   | **AWS Audit Manager** (`auditmanager.amazonaws.com`)                                                | Centralized evidence collection for audits.                                                             | -         |
|   ❌   | **CloudTrail** (`cloudtrail.amazonaws.com`)                                                         | Org-wide API event logging.                                                                             | -         |
|   ❌   | **CloudWatch** (`observabilityadmin.amazonaws.com`)                                                 | Org-wide view of telementry.                                                                            | -         |
|   ❌   | **Control Tower** (`controltower.amazonaws.com`)                                                    | Set up and govern a secure, compliant, multi-account AWS environment                                    | -         |
|   ❌   | **DevOps Guru** (`devops-guru.amazonaws.com`)                                                       | Detects an operational issue or risk                                                                    | -         |
|   ❌   | **Directory Service**                                                                               | Set up and run directories in the AWS Cloud                                                             | -         |
|   ❌   | **EventBridge**                                                                                     | Share all EventBridge events across all accounts.                                                       | -         |
|   ❌   | **Elastic Compute Cloud** (`ec2.amazonaws.com`)                                                     | Generate reports of existing EC2 configurations.                                                        | -         |
|   ❌   | **EC2 Capacity Manager** (`ec2.capacitymanager.amazonaws.com`)                                      | Org-wide view of of EC2 capacity usage.                                                                 | -         |
|   ❌   | **Elastic Kubernetes Service** (`dashboard.eks.amazonaws.com`)                                      | Central dashboard of EKS usage.                                                                         | -         |
|   ❌   | **Marketplace - Private Marketplace** (`private-marketplace.marketplace.amazonaws.com`)             | Private marketplaces associated with our organisation.                                                  | -         |
|   ❌   | **Marketplace - Procurement Insights Dashboard** (`procurement-insights.marketplace.amazonaws.com`) | Private marketplaces associated with our organisation.                                                  | -         |
|   ❌   | **Network Manager** (`networkmanager.amazonaws.com`)                                                | Cross Account Network Management.                                                                       | -         |
|   ❌   | **Amazon Q** (`q.amazonaws.com`)                                                                    | Paid subscription to Amaazon Q.                                                                         | -         |
|   ❌   | **Resource Explorer** (`resource-explorer-2.amazonaws.com`)                                         | Multi-account search of reasources.                                                                     | -         |
|   ❌   | **Security Incident Response** (`security-ir.amazonaws.com`)                                        | Security service that provides 24/7 live, human-assisted security incident support.                     | -         |
|   ❌   | **Security Lake** (`securitylake.amazonaws.com`)                                                    | Create a data lake that collects logs and events across your accounts.                                  | -         |
|   ❌   | **Service Catalog** (`servicecatalog.amazonaws.com`)                                                | Create and manage catalogs of IT services that are approved for use.                                    | -         |
|   ❌   | **Service Quotas** (`servicequotas.amazonaws.com`)                                                  | View and manage your service quotas.                                                                    | -         |
|   ❌   | **Systems Manager** (`ssm.amazonaws.com`)                                                           | Enable Visibility and Control of AWS Resources.                                                         | -         |
|   ❌   | **User Notifications** (`notifications.amazon.com`)                                                 | Configure and view notifications centrally across accounts in your organization.                        | -         |
|   ❌   | **Well Architected Tool** (`wellarchitected.amazonaws.com`)                                         | Helps document the state of workloads and compares them to the latest AWS architectural best practices. | -         |
|   ❌   | **VPC Reachability Analyzer** (`reachabilityanalyzer.networkinsights.amazonaws.com`)                | Trace paths across accounts in your organizations.                                                      | -         |

</details>

## 🧠 Runbooks

Practical step-by-step guidance for manual or operational tasks.

<details>
<summary>🔁 Run GitHub SCIM Sync Job</summary>

Syncing GitHub Teams into AWS Identity Centre is one of the core services of the AWS Root Account.

This process enables users to seamlessly login to AWS Accounts using their GitHub Identities.

Although this processes is automated to run on a schedule, you may sometimes need to run it manually.

It is perfectly safe to run manually via the console and will not cause any issues doing so.

**Steps:**

- SSO into the `MoJ Master` account as an `ModernisationPlatformEngineer`.
- Navigate to the "Lambda" service.
- Change your Region is set to eu-west-2 (London).
- Navigate to the "Functions" on the sidebar.
- Select `aws-sso-scim-github`.
- Select the `Test` tab.
- Select `Create new event`.
- Enter any name for the `Event name` such as `RunJobManually`.
- Enter a blank JSON object for the test data i.e. `{}`.
- Press the `Test` button, this will trigger the SCIM job.
- After a couple of minutes, the job should complete and display the logs of the run. You can use the logs to confirm which users have been added to which team if the request to run the job manually came from an individual.

_Validate:_ You can check AWS Identity Centre to validate if the expected users have gained the expected access to AWS Accounts and Applications.

</details>

<details>
<summary>🔐 Assign Access to an AWS Account</summary>

Grant a user or group access to a specific AWS account and permission set.

**Steps:**

- Identify the correct Azure AD group or GitHub Team corresponding to the AWS account and role.
- If no existing group exists for the access you need, you will have to raise a PR to assign a group with permissions you require.
- Add the user into the Azure AD group or GitHub Team.
- Run a SCIM sync manually (or wait for the automatic run).
- Confirm access in AWS IAM Identity Center → “Assignments”.

_Validate:_ User can log in to AWS SSO and see the assigned account.

</details>

## 📚 Further Reading

- [AWS Organizations Overview](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_introduction.html)
- [AWS SSO (IAM Identity Center) Documentation](https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html)
- [MoJ Cloud Platform Guidance](https://user-guide.modernisation-platform.service.justice.gov.uk)
- [MoJ Modernisation Platform Guidance](https://user-guide.modernisation-platform.service.justice.gov.uk/)
- [Terraform Best Practices (HashiCorp)](https://developer.hashicorp.com/terraform/docs/language/best-practices)
