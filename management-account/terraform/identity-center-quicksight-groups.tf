resource "aws_identitystore_group" "analytical_platform_qs_readers" {
  display_name      = "azure-aws-sso-analytical-platform-qs-readers"
  description       = "Analytical Platform QuickSight Readers (membership managed via AP Control Panel)"
  identity_store_id = tolist(data.aws_ssoadmin_instances.moj.identity_store_ids)[0]
}

resource "aws_identitystore_group" "analytical_platform_qs_authors" {
  display_name      = "azure-aws-sso-analytical-platform-qs-authors"
  description       = "Analytical Platform QuickSight Authors (membership managed via AP Control Panel)"
  identity_store_id = tolist(data.aws_ssoadmin_instances.moj.identity_store_ids)[0]
}

resource "aws_identitystore_group" "analytical_platform_qs_admins" {
  display_name      = "azure-aws-sso-analytical-platform-qs-admins"
  description       = "Analytical Platform QuickSight Admins (membership managed via AP Control Panel)"
  identity_store_id = tolist(data.aws_ssoadmin_instances.moj.identity_store_ids)[0]
}