output "role_arn" {
  value       = aws_iam_role.user-role-tf.arn
  description = "Wiz Access Role ARN"
}

output "wiz_last_updated" {
  value       = local.wiz_version_last_updated
  description = "Wiz Version Last Updated Timestamp"
}
