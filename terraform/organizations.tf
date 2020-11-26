resource "aws_organizations_organization" "default" {
  aws_service_access_principals = [
    "sso.amazonaws.com"
  ]
  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY"
  ]
  feature_set = "ALL"
}
