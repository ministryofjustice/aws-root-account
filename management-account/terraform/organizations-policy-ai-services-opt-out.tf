#######################
# AI Services Opt-out #
#######################

# See https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_ai-opt-out.html for more information
# Note: This doesn't stop the usage of services, but opts out of data being used to train AWS AI models.

resource "aws_organizations_policy" "ai_services_opt_out" {
  name        = "ai-services-opt-out"
  description = "An AI Services Opt-out policy to opt-out of content/data processing to train AWS AI models."
  type        = "AISERVICES_OPT_OUT_POLICY"
  tags        = {}

  # This policy does the following:
  # - opts out all eligible services (by defaulting to opt-out) for data usage
  # - disallows child policies to overwrite any level of the policy
  content = <<CONTENT
{
  "services": {
    "@@operators_allowed_for_child_policies": ["@@none"],
    "default": {
      "@@operators_allowed_for_child_policies": ["@@none"],
      "opt_out_policy": {
        "@@operators_allowed_for_child_policies": ["@@none"],
        "@@assign": "optOut"
      }
    }
  }
}
CONTENT
}

# Attach policy to root (i.e. target all AWS accounts in the organisation)
resource "aws_organizations_policy_attachment" "ai_services_opt_out" {
  policy_id = aws_organizations_policy.ai_services_opt_out.id
  target_id = aws_organizations_organization.default.roots[0].id
}
