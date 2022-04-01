#################################
# Firewall Manager in eu-west-2 #
#################################

# Shield Advanced policy
resource "aws_fms_policy" "eu_west_2_modernisation_platform_shield_advanced" {
  name                               = "modernisation-platform"
  delete_all_policy_resources        = true
  delete_unused_fm_managed_resources = false
  exclude_resource_tags              = false
  remediation_enabled                = true
  resource_type_list = [
    "AWS::EC2::EIP",
    "AWS::ElasticLoadBalancing::LoadBalancer",
    "AWS::ElasticLoadBalancingV2::LoadBalancer",
  ]

  include_map {
    account = toset([
      for name, id in local.accounts.modernisation_platform_shield_advanced :
      id
    ])
  }

  resource_tags = {
    is-production = "false"
  }

  security_service_policy_data {
    type = "SHIELD_ADVANCED"
    managed_service_data = jsonencode({
      type = "SHIELD_ADVANCED"
    })
  }
}
