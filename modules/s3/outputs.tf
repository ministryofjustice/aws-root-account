output "bucket_name" {
  value = aws_s3_bucket.default.id
}

output "bucket" {
  value = aws_s3_bucket.default
}
