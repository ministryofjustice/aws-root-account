# Service-linked roles
resource "aws_iam_service_linked_role" "compute-optimizer" {
  aws_service_name = "compute-optimizer.amazonaws.com"
}

resource "aws_iam_service_linked_role" "guardduty" {
  aws_service_name = "guardduty.amazonaws.com"
}

resource "aws_iam_service_linked_role" "organizations" {
  aws_service_name = "organizations.amazonaws.com"
  description      = "Service-linked role used by AWS Organizations to enable integration of other AWS services with Organizations."
}

resource "aws_iam_service_linked_role" "resource-access-manager" {
  aws_service_name = "ram.amazonaws.com"
}

resource "aws_iam_service_linked_role" "securityhub" {
  aws_service_name = "securityhub.amazonaws.com"
  description      = "A service-linked role required for AWS Security Hub to access your resources."
}

resource "aws_iam_service_linked_role" "sso" {
  aws_service_name = "sso.amazonaws.com"
  description      = "Service-linked role used by AWS SSO to manage AWS resources, including IAM roles, policies and SAML IdP on your behalf."
}

resource "aws_iam_service_linked_role" "storage-lens" {
  aws_service_name = "storage-lens.s3.amazonaws.com"
}

resource "aws_iam_service_linked_role" "support" {
  aws_service_name = "support.amazonaws.com"
  description      = "Enables resource access for AWS to provide billing, administrative and support services"
}

resource "aws_iam_service_linked_role" "trustedadvisor" {
  aws_service_name = "trustedadvisor.amazonaws.com"
  description      = "Access for the AWS Trusted Advisor Service to help reduce cost, increase performance, and improve security of your AWS environment."
}

resource "aws_iam_service_linked_role" "trustedadvisor-reporting" {
  aws_service_name = "reporting.trustedadvisor.amazonaws.com"
  description      = "Service Linked Role assumed by Trusted Advisor for multi account reporting."
}

# Other roles
## IAM ReadOnly Access Role
data "aws_iam_policy_document" "iam-read-only-access-assume-role" {
  version = "2012-10-17"

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.caller_identity.account_id}:root"]
    }
  }
}

resource "aws_iam_role" "iam-read-only-access-role" {
  name               = "IAMReadOnlyAccessRole"
  assume_role_policy = data.aws_iam_policy_document.iam-read-only-access-assume-role.json
}

## lambda_basic_execution-test
data "aws_iam_policy_document" "lambda_basic_execution-test-assume-role" {
  version = "2012-10-17"

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_basic_execution-test" {
  name               = "lambda_basic_execution-test"
  assume_role_policy = data.aws_iam_policy_document.lambda_basic_execution-test-assume-role.json
}

## lambda-iam-generate-report-role
data "aws_iam_policy_document" "lambda-iam-generate-report-role-assume-role" {
  version = "2012-10-17"

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda-iam-generate-report-role" {
  name               = "lambda-iam-generate-report-role"
  path               = "/service-role/"
  assume_role_policy = data.aws_iam_policy_document.lambda-iam-generate-report-role-assume-role.json

  tags = {}
}
