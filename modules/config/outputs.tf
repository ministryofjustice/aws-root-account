output "iam_role_arn" {
  value = var.create_iam_role ? aws_iam_role.config["enabled"].arn : var.iam_role_arn
}
