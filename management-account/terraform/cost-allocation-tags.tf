resource "aws_ce_cost_allocation_tag" "example" {
  for_each = local.cost-allocation-tags
  tag_key  = each.key
  status   = "Active"
}
