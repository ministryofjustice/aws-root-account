# Central Digital OU
resource "aws_organizations_account" "cloud-networks-psn" {
  name      = "Cloud Networks PSN"
  email     = local.aws_account_email_addresses["Cloud Networks PSN"][0]
  parent_id = aws_organizations_organizational_unit.central-digital.id

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

resource "aws_organizations_account" "moj-digital-services" {
  name      = "MoJ Digital Services"
  email     = local.aws_account_email_addresses["MoJ Digital Services"][0]
  parent_id = aws_organizations_organizational_unit.central-digital.id

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

resource "aws_organizations_account" "network-architecture" {
  name      = "Network Architecture"
  email     = local.aws_account_email_addresses["Network Architecture"][0]
  parent_id = aws_organizations_organizational_unit.central-digital.id

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

resource "aws_organizations_account" "moj-cla" {
  name      = "MoJ CLA"
  email     = local.aws_account_email_addresses["MoJ CLA"][0]
  parent_id = aws_organizations_organizational_unit.central-digital.id

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

resource "aws_organizations_account" "patterns" {
  name      = "Patterns"
  email     = local.aws_account_email_addresses["Patterns"][0]
  parent_id = aws_organizations_organizational_unit.central-digital.id

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
