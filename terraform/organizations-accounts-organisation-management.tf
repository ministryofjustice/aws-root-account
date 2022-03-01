locals {
  tags-organisation-management = {
    application            = "Organisation Management"
    business-unit          = "Platforms"
    infrastructure-support = "Hosting Leads: hosting-leads@digital.justice.gov.uk"
    is-production          = true
    owner                  = "Hosting Leads: hosting-leads@digital.justice.gov.uk"
    source-code            = "github.com/ministryofjustice/aws-root-account"
  }
}

# Organisation security account
resource "aws_organizations_account" "organisation-security" {
  name      = "organisation-security"
  email     = replace(local.aws_account_email_addresses_template, "{email}", "organisation-security")
  parent_id = aws_organizations_organizational_unit.organisation-management.id

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

  tags = merge(
    local.tags-organisation-management, {
      component = "Security"
    }
  )
}
