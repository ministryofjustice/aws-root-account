locals {
  tags_default = {
    is-production = false
  }
  github_repository = "github.com/ministryofjustice/aws-root-account/blob/main"

  tags_organisation_management = {
    application            = "Organisation Management"
    business-unit          = "Platforms"
    infrastructure-support = "Hosting Leads: hosting-leads@digital.justice.gov.uk"
    is-production          = true
    owner                  = "Hosting Leads: hosting-leads@digital.justice.gov.uk"
    source-code            = "github.com/ministryofjustice/aws-root-account"
  }

  azuread_group_members = toset([for group_id, group_data in data.azuread_group.entraid_group_data :
    flatten([group_data.members, group_data.owners])
  ])

  group_memberships = flatten([
    for group_name, group_data in data.azuread_group.entraid_group_data : [
      for member in distinct(concat(group_data.members, group_data.owners)) : {
        group_name  = group_name
        member_name = member
      }
    ]
  ])
}

