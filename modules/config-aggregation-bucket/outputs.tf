output "s3_bucket_arn" {
  value = module.bucket.bucket.arn
}

output "s3_bucket_name" {
  value = module.bucket.bucket.bucket
}
