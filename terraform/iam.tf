data "aws_organizations_organization" "org" {}

locals {
  account_ids = {
    for account in data.aws_organizations_organization.org.accounts :
    lower(account.email) => account.id
  }
}

resource "aws_iam_role" "terraform-modernisation-platform-organisation-management-role" {
  name               = "ModernisationPlatformOrganisationManagementRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${local.account_ids["aws+modernisation-platform@digital.justice.gov.uk"]}:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "organisation-management" {
  statement {
    sid    = "DenyAllApartFromOrganisationManagement"
    effect = "Deny"
    not_actions = [
      # Note that this doesn't allow the account to delete Organisational Units
      "organizations:DescribeOrganization",
      "organizations:DescribeOrganizationalUnit",
      "organizations:CreateOrganizationalUnit",
      "organizations:UpdateOrganizationalUnit",
      "organizations:CreateAccount",
      "organizations:MoveAccount",
      "iam:CreateServiceLinkedRole"
    ]
    resources = [
      "arn:aws:organizations:::*"
    ]
  }
}

resource "aws_iam_policy" "terraform-organisation-management-policy" {
  name        = "TerraformOrganisationManagementPolicy"
  description = "A policy that allows the Modernisation Platform to manage organisations"
  policy      = data.aws_iam_policy_document.organisation-management.json
}

resource "aws_iam_role_policy_attachment" "terraform-organisation-management-attachment" {
  role       = aws_iam_role.terraform-modernisation-platform-organisation-management-role.name
  policy_arn = aws_iam_policy.terraform-organisation-management-policy.arn
}
