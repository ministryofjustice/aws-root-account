locals {
  organisation_security_account_id = coalesce([
    for account in data.aws_organizations_organization.default.accounts :
    account.id
    if account.name == "organisation-security"
  ]...)

  # Accounts map
  accounts = {
    active_only_not_self : {
      for account in data.aws_organizations_organization.default.accounts :
      account.name => account.id
      if account.status == "ACTIVE" && account.name != "organisation-security"
    }
  }
}
