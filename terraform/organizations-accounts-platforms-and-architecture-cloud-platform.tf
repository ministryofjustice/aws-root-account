# Platforms & Architecture OU: Cloud Platform
resource "aws_organizations_account" "cloud-platform-transit-gateways" {
  name      = "Cloud Platform Transit Gateways"
  email     = local.aws_account_email_addresses["Cloud Platform Transit Gateways"][0]
  parent_id = aws_organizations_organizational_unit.platforms-and-architecture-cloud-platform.id

  lifecycle {
    # If any of these attributes are changed, it attempts to destroy and recreate the account,
    # so we should ignore the changes to prevent this from happening.
    ignore_changes = [
      name,
      email,
      iam_user_access_to_billing,
      role_name
    ]
  }
}

resource "aws_organizations_account" "cloud-platform-ephemeral-test" {
  name      = "Cloud Platform Ephemeral Test"
  email     = local.aws_account_email_addresses["Cloud Platform Ephemeral Test"][0]
  parent_id = aws_organizations_organizational_unit.platforms-and-architecture-cloud-platform.id

  lifecycle {
    # If any of these attributes are changed, it attempts to destroy and recreate the account,
    # so we should ignore the changes to prevent this from happening.
    ignore_changes = [
      name,
      email,
      iam_user_access_to_billing,
      role_name
    ]
  }
}

resource "aws_organizations_account" "cloud-platform" {
  name      = "Cloud Platform"
  email     = local.aws_account_email_addresses["Cloud Platform"][0]
  parent_id = aws_organizations_organizational_unit.platforms-and-architecture-cloud-platform.id

  lifecycle {
    # If any of these attributes are changed, it attempts to destroy and recreate the account,
    # so we should ignore the changes to prevent this from happening.
    ignore_changes = [
      name,
      email,
      iam_user_access_to_billing,
      role_name
    ]
  }
}
