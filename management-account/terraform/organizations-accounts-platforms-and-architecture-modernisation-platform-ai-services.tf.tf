resource "aws_organizations_account" "modernisation_platform_ai_services" {
  name                       = "Modernisation Platform AI Services"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "modernisation-platform")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.platforms_and_architecture_modernisation_platform_ai_services.id
  close_on_deletion          = true

  tags = merge(local.tags_platforms, {
    is-production          = true
    application            = "Modernisation Platform AI Services"
    environment-name       = "mp-ai-landing-zone"
    infrastructure-support = "Modernisation Platform AI Services: modernisation-platform@digital.justice.gov.uk"
    owner                  = "Modernisation Platform AI Services: modernisation-platform@digital.justice.gov.uk"
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

