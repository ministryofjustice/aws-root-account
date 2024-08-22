resource "aws_ce_cost_allocation_tag" "main" {
  for_each = local.cost_allocation_tags

  tag_key = each.key
  status  = "Active"
}
