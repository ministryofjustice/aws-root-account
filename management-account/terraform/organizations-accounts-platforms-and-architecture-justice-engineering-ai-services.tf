resource "aws_organizations_account" "justice_engineering_ai_services" {
  name                       = "Justice Engineering AI Services"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "modernisation-platform")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.platforms_and_architecture_justice_engineering_ai_services.id
  close_on_deletion          = true

  tags = merge(local.tags_platforms, {
    is-production          = true
    application            = "Justice Engineering AI Services"
    environment-name       = "justice-engineering-ai-landing-zone"
    infrastructure-support = "Justice Engineering AI Services: modernisation-platform+ai@digital.justice.gov.uk"
    owner                  = "Justice Engineering AI Services: modernisation-platform+ai@digital.justice.gov.uk"
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

