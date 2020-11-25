resource "aws_iam_group" "admins" {
  name = "Admin"
}

resource "aws_iam_group" "artifacts" {
  name = "Artifact"
}

resource "aws_iam_group" "aws_organisations_service_admins" {
  name = "AWSOrganisationsAdmin"
}

resource "aws_iam_group" "billing_full_access" {
  name = "BillingFullAccess"
}

resource "aws_iam_group" "iam_read_only_group" {
  name = "IAMReadOnlyGroup"
}
