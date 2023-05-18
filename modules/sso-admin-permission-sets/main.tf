resource "aws_ssoadmin_permission_set" "this" {
  name             = var.name
  description      = var.description
  instance_arn     = var.sso_admin_instance_arn
  session_duration = var.session_duration
  tags             = var.tags
}

resource "aws_ssoadmin_managed_policy_attachment" "this" {
  for_each           = toset(var.managed_policy_arns)
  instance_arn       = var.sso_admin_instance_arn
  managed_policy_arn = each.value
  permission_set_arn = aws_ssoadmin_permission_set.this.arn
}

resource "aws_ssoadmin_permission_set_inline_policy" "this" {
  count              = var.inline_policy != "" ? 1 : 0
  instance_arn       = var.sso_admin_instance_arn
  inline_policy      = var.inline_policy
  permission_set_arn = aws_ssoadmin_permission_set.this.arn
}
