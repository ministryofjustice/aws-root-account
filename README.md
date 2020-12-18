# AWS Root Account
This repository holds Terraform for the Ministry of Justice AWS root account.

## AWS Organizations

All accounts defined in here form part of the [AWS Organization](https://aws.amazon.com/organizations/) configuration for the Ministry of Justice, allowing us to use [certain services](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_integrate_services_list.html) for organisational audit, governance, security, and cost optimisation.

## Services

We centrally manage:

- [x] [AWS Compute Optimizer](https://docs.aws.amazon.com/compute-optimizer/latest/ug/what-is.html)
- [x] [AWS Resource Access Manager (RAM)](https://docs.aws.amazon.com/ram/latest/userguide/)
- [x] [AWS Single Sign-On (SSO)](https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html)
- [x] [AWS Trusted Advisor (Organisational overview)](https://docs.aws.amazon.com/organizations/latest/userguide/services-that-can-integrate-ta.html)
