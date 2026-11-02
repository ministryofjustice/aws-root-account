output "bucket_name" {
  value = aws_s3_bucket.default.id
}

output "bucket" {
  value = {
    arn    = aws_s3_bucket.default.arn
    bucket = aws_s3_bucket.default.bucket
  }
}

output "replication_configuration" {
  value = var.enable_replication ? {
    for key, configuration in aws_s3_bucket_replication_configuration.default : key => {
      id     = configuration.id
      bucket = configuration.bucket
      role   = configuration.role
    }
  } : null
  description = "Replication configuration for the S3 bucket"
}

output "replication_role_arn" {
  value       = length(aws_iam_role.replication_role) > 0 ? aws_iam_role.replication_role[0].arn : null
  description = "ARN of the replication role if it exists"
}
