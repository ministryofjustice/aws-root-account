# AWS Organizations: AI Services Opt-out policy
# See: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_ai-opt-out.html
# Note that this doesn't stop the usage of the services, but opts out of the data being used to train
# AWS AI models.
resource "aws_organizations_policy" "ai-services-opt-out-policy" {
  name        = "ai-services-opt-out"
  description = "An AI Services Opt-out policy to opt-out of content/data processing to train AWS AI models."
  type        = "AISERVICES_OPT_OUT_POLICY"

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
