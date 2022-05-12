resource "aws_organizations_account" "cloud_platform" {
  name                       = "Cloud Platform"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "cloud-platform")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.platforms_and_architecture_cloud_platform.id

  tags = merge(local.tags_platforms, {
    is-production = true
  })

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "cloud_platform_ephemeral_test" {
  name                       = "Cloud Platform Ephemeral Test"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "cloud-platform-ephemeral-test")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.platforms_and_architecture_cloud_platform.id

  tags = merge(local.tags_platforms, {

  })

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}
