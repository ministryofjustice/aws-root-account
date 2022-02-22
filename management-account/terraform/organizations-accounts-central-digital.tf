locals {
  tags_central_digital = merge(local.tags_business_units.hq)
}

resource "aws_organizations_account" "moj_digital_services" {
  name                       = "MoJ Digital Services"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.central_digital.id

  tags = local.tags_central_digital

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "network_architecture" {
  name                       = "Network Architecture"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "network-architecture")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.central_digital.id

  tags = local.tags_central_digital

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}

resource "aws_organizations_account" "patterns" {
  name                       = "Patterns"
  email                      = replace(local.aws_account_email_addresses_template, "{email}", "patterns")
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.central_digital.id

  tags = local.tags_central_digital

  lifecycle {
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
  }
}
