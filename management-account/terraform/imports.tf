import {
  to = aws_ssoadmin_account_assignment.github_team_access["cloud-platform-engineers-754256621582-arn:aws:sso:::permissionSet/ssoins-7535d9af4f41fb26/ps-4fe7bf47e9790ed6"]
  id = "664252b4-7021-701e-49b9-6c46ccc7899e,GROUP,754256621582,AWS_ACCOUNT,arn:aws:sso:::permissionSet/ssoins-7535d9af4f41fb26/ps-4fe7bf47e9790ed6,arn:aws:sso:::instance/ssoins-7535d9af4f41fb26"
}

import {
  to = aws_ssoadmin_account_assignment.github_team_access["webops-754256621582-arn:aws:sso:::permissionSet/ssoins-7535d9af4f41fb26/ps-314024a5720eec87"]
  id = "9c6710dd7f-0e43e021-1707-4fea-ab53-3b9eb9cf785c,GROUP,754256621582,AWS_ACCOUNT,arn:aws:sso:::permissionSet/ssoins-7535d9af4f41fb26/ps-314024a5720eec87,arn:aws:sso:::instance/ssoins-7535d9af4f41fb26"
}

# Registered by the 3 Nov apply, which errored (InsufficientDependencyServiceAccessPermissionException) before
# saving state; later applies fail with AccountRegisteredException
import {
  to = aws_cloudtrail_organization_delegated_admin_account.organisation_security
  id = aws_organizations_account.organisation_security.id
}

# Organisation CloudTrail: adopted from organisation-security, which created it as CloudTrail delegated administrator
# (3 Nov 2026) but cannot manage it with Terraform. The AWS provider reads a trail with DescribeTrails by ARN, and an
# organisation trail's ARN always carries the management account ID (the management account owns it, whoever creates
# it). CloudTrail rejects that read from any other account ("Account number does not match caller's account"), so
# every plan in organisation-security would fail. Paired with the removed block in organisation-security/terraform/
# cloudtrail.tf; both blocks can be deleted once applied.
import {
  to = aws_cloudtrail.organisation
  id = local.organisation_cloudtrail_arn
}
