module "cloudtrail" {
  source      = "../../modules/cloudtrail"
  bucket_name = module.cloudtrail_s3_bucket.bucket_name
}

###########################
# Organisation CloudTrail #
###########################
# The trail itself is managed in management-account/terraform/cloudtrail.tf; this account keeps its bucket, KMS key,
# SNS topic, SQS queue and Wiz access.
#
# Why not here: this account created the trail as CloudTrail delegated administrator (3 Nov 2026), but Terraform cannot
# manage it from here. The AWS provider reads a trail with DescribeTrails by ARN, an organisation trail's ARN always
# carries the management account ID (the management account owns organisation trails, whoever creates them), and
# CloudTrail rejects that read from any other account ("Account number does not match caller's account"). Every plan
# here would fail. Managing it here via a provider that assumes a role in the management account would give this
# account write access to the management account, so it is managed from there instead.
#
# This removed block hands the trail over without touching it (destroy = false); the matching import is in
# management-account/terraform/imports.tf. Both can be deleted once applied.
removed {
  from = aws_cloudtrail.organisation

  lifecycle {
    destroy = false
  }
}
