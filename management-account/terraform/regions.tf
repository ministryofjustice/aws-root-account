

# Enable non-default regions for modernisation platform accounts

resource "aws_account_region" "modernisation_platform_accounts" {
  for_each = {
    for combo in setproduct(local.non_default_enabled_regions, local.modernisation_platform_account_ids) :
    "${combo[0]}-${combo[1]}" => {
      region     = combo[0]
      account_id = combo[1]
    }
  }
  account_id  = each.value.account_id
  region_name = each.value.region
  enabled     = true
}

# Enable non-default regions for management account

resource "aws_account_region" "management_account" {
  for_each    = toset(local.non_default_enabled_regions)
  region_name = each.value
  enabled     = true
}

# Enable non-default regions for organisation security account

resource "aws_account_region" "organisation_security_account" {
  for_each    = toset(local.non_default_enabled_regions)
  account_id  = aws_organizations_account.organisation_security.id
  region_name = each.value
  enabled     = true
}
