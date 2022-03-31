#tfsec:ignore:aws-s3-enable-bucket-encryption tfsec:ignore:aws-s3-enable-bucket-logging tfsec:ignore:aws-s3-specify-public-access-block tfsec:ignore:aws-s3-specify-public-access-block tfsec:ignore:aws-s3-enable-versioning tfsec:ignore:aws-s3-block-public-acls tfsec:ignore:aws-s3-block-public-policy tfsec:ignore:aws-s3-ignore-public-acls tfsec:ignore:aws-s3-no-public-buckets tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket" "default" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  tags = var.additional_tags
}

resource "aws_s3_bucket_acl" "default" {
  bucket = aws_s3_bucket.default.id
  acl    = var.bucket_acl
}
