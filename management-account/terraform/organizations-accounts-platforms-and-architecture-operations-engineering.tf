resource "aws_organizations_account" "moj_digital_services" {
  name                       = "MoJ Digital Services"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.platforms_and_architecture_operations_engineering.id

  tags = merge(local.tags_platforms, {
    is-production          = true
    application            = "DNS and legacy services"
    environment-name       = "moj-dsd"
    infrastructure-support = "Operations Engineering: operations-engineering@digital.justice.gov.uk"
    owner                  = "Operations Engineering: operations-engineering@digital.justice.gov.uk"
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
