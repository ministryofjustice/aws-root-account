# HMPPS OU: Delius
resource "aws_organizations_account" "alfresco-non-prod" {
  name      = "Alfresco non-prod"
  email     = local.aws_account_email_addresses["Alfresco non-prod"][0] # TODO: Move this into AWS Secrets Manager
  parent_id = aws_organizations_organizational_unit.hmpps-delius.id

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

resource "aws_organizations_policy_attachment" "alfresco-non-prod" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.alfresco-non-prod.id
}

resource "aws_organizations_account" "hmpps-delius-training" {
  name      = "HMPPS Delius Training"
  email     = local.aws_account_email_addresses["HMPPS Delius Training"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-delius.id

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

resource "aws_organizations_policy_attachment" "hmpps-delius-training" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmpps-delius-training.id
}

resource "aws_organizations_account" "hmpps-delius-mis-test" {
  name      = "HMPPS Delius MIS Test"
  email     = local.aws_account_email_addresses["HMPPS Delius MIS Test"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-delius.id

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

resource "aws_organizations_policy_attachment" "hmpps-delius-mis-test" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmpps-delius-mis-test.id
}

resource "aws_organizations_account" "delius-new-tech-non-prod" {
  name      = "Delius New Tech non-prod"
  email     = local.aws_account_email_addresses["Delius New Tech non-prod"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-delius.id

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

resource "aws_organizations_policy_attachment" "delius-new-tech-non-prod" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.delius-new-tech-non-prod.id
}

resource "aws_organizations_account" "hmpps-delius-training-test" {
  name      = "HMPPS Delius Training Test"
  email     = local.aws_account_email_addresses["HMPPS Delius Training Test"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-delius.id

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

resource "aws_organizations_policy_attachment" "hmpps-delius-training-test" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmpps-delius-training-test.id
}

resource "aws_organizations_account" "hmpps-delius-pre-production" {
  name      = "HMPPS Delius Pre Production"
  email     = local.aws_account_email_addresses["HMPPS Delius Pre Production"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-delius.id

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

resource "aws_organizations_policy_attachment" "hmpps-delius-pre-production" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmpps-delius-pre-production.id
}

resource "aws_organizations_account" "hmpps-delius-po-test" {
  name      = "HMPPS Delius PO Test"
  email     = local.aws_account_email_addresses["HMPPS Delius PO Test"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-delius.id

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

resource "aws_organizations_policy_attachment" "hmpps-delius-po-test" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmpps-delius-po-test.id
}

resource "aws_organizations_account" "hmpps-delius-mis-non-prod" {
  name      = "HMPPS Delius MIS non prod"
  email     = local.aws_account_email_addresses["HMPPS Delius MIS non prod"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-delius.id

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

resource "aws_organizations_policy_attachment" "hmpps-delius-mis-non-prod" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmpps-delius-mis-non-prod.id
}

resource "aws_organizations_account" "hmpps-delius-po-test-1" {
  name      = "HMPPS Delius PO Test 1"
  email     = local.aws_account_email_addresses["HMPPS Delius PO Test 1"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-delius.id

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

resource "aws_organizations_policy_attachment" "hmpps-delius-po-test-1" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmpps-delius-po-test-1.id
}

resource "aws_organizations_account" "delius-core-non-prod" {
  name      = "Delius Core non-prod"
  email     = local.aws_account_email_addresses["Delius Core non-prod"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-delius.id

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

resource "aws_organizations_policy_attachment" "delius-core-non-prod" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.delius-core-non-prod.id
}

resource "aws_organizations_account" "probation-management-non-prod" {
  name      = "Probation Management non-prod"
  email     = local.aws_account_email_addresses["Probation Management non-prod"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-delius.id

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

resource "aws_organizations_policy_attachment" "probation-management-non-prod" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.probation-management-non-prod.id
}

resource "aws_organizations_account" "hmpps-delius-stage" {
  name      = "HMPPS Delius Stage"
  email     = local.aws_account_email_addresses["HMPPS Delius Stage"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-delius.id

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

resource "aws_organizations_policy_attachment" "hmpps-delius-stage" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmpps-delius-stage.id
}

resource "aws_organizations_account" "hmpps-delius-test" {
  name      = "HMPPS Delius Test"
  email     = local.aws_account_email_addresses["HMPPS Delius Test"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-delius.id

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

resource "aws_organizations_policy_attachment" "hmpps-delius-test" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmpps-delius-test.id
}

resource "aws_organizations_account" "hmpps-delius-po-test-2" {
  name      = "HMPPS Delius PO Test 2"
  email     = local.aws_account_email_addresses["HMPPS Delius PO Test 2"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-delius.id

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

resource "aws_organizations_policy_attachment" "hmpps-delius-po-test-2" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmpps-delius-po-test-2.id
}

resource "aws_organizations_account" "hmpps-delius-performance" {
  name      = "HMPPS Delius Performance"
  email     = local.aws_account_email_addresses["HMPPS Delius Performance"][0]
  parent_id = aws_organizations_organizational_unit.hmpps-delius.id

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

resource "aws_organizations_policy_attachment" "hmpps-delius-performance" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.hmpps-delius-performance.id
}
