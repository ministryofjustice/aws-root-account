# Define Cost Allocation Tags

resource "aws_ce_cost_allocation_tag" "cost_allocation_tags" {
  for_each = toset(local.active_tags)

  tag_key = each.value
  status  = "Active"
}

# Import Existing Active Cost Allocation Tags

import {
  for_each = toset(local.active_tags)
  to       = aws_ce_cost_allocation_tag.cost_allocation_tags[each.value]
  id       = each.value
}

