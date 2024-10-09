output "bucket_name" {
  value = aws_s3_bucket.default.id
}

output "bucket" {
  value = aws_s3_bucket.default
}

output "replication_configuration" {
  value       = var.enable_replication ? aws_s3_bucket_replication_configuration.default : null
  description = "Replication configuration for the S3 bucket"
}

output "replication_role_arn" {
  value       = length(aws_iam_role.replication_role) > 0 ? aws_iam_role.replication_role[0].arn : null
  description = "ARN of the replication role if it exists"
}
