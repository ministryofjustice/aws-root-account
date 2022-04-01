##############
# S3 buckets #
##############

# cloudtrail--replication20210315101340520100000002
module "cloudtrail_replication_s3_bucket" {
  providers = {
    aws = aws.eu-west-1
  }
  source = "../../modules/s3"

  bucket_name   = "cloudtrail--replication20210315101340520100000002"
  attach_policy = true
  policy        = data.aws_iam_policy_document.cloudtrail_replication_s3_bucket.json

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = module.cloudtrail.kms_key_arn
      }
    }
  }
}

data "aws_iam_policy_document" "cloudtrail_replication_s3_bucket" {
  statement {
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::cloudtrail--replication20210315101340520100000002/*",
      "arn:aws:s3:::cloudtrail--replication20210315101340520100000002"
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

# cloudtrail-20210315101356188000000003
module "cloudtrail_s3_bucket" {
  source = "../../modules/s3"

  bucket_name   = "cloudtrail-20210315101356188000000003"
  bucket_acl    = "log-delivery-write"
  attach_policy = true
  policy        = data.aws_iam_policy_document.cloudtrail_s3_bucket.json

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = module.cloudtrail.kms_key_arn
      }
    }
  }
}

data "aws_iam_policy_document" "cloudtrail_s3_bucket" {
  statement {
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::cloudtrail-20210315101356188000000003/*",
      "arn:aws:s3:::cloudtrail-20210315101356188000000003"
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::cloudtrail-20210315101356188000000003"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::cloudtrail-20210315101356188000000003/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

# log-bucket-replication20210315101330747900000001
module "log_bucket_replication_s3_bucket" {
  providers = {
    aws = aws.eu-west-1
  }
  source = "../../modules/s3"

  bucket_name   = "log-bucket-replication20210315101330747900000001"
  attach_policy = true
  policy        = data.aws_iam_policy_document.log_bucket_replication_s3_bucket.json

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "aws:kms"
      }
    }
  }
}

data "aws_iam_policy_document" "log_bucket_replication_s3_bucket" {
  statement {
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::log-bucket-replication20210315101330747900000001/*",
      "arn:aws:s3:::log-bucket-replication20210315101330747900000001"
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

# log-bucket20210315101344444500000002
module "log_bucket_s3_bucket" {
  source = "../../modules/s3"

  bucket_name   = "log-bucket20210315101344444500000002"
  attach_policy = true
  policy        = data.aws_iam_policy_document.log_bucket_s3_bucket.json

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "aws:kms"
      }
    }
  }
}

data "aws_iam_policy_document" "log_bucket_s3_bucket" {
  statement {
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::log-bucket20210315101344444500000002/*",
      "arn:aws:s3:::log-bucket20210315101344444500000002"
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

# moj-aws-root-account-terraform-state
module "terraform_state_s3_bucket" {
  source = "../../modules/s3"

  bucket_name = "moj-aws-root-account-terraform-state"

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "aws:kms"
      }
    }
  }
}

# moj-cur-reports
module "cur_reports_s3_bucket" {
  source = "../../modules/s3"

  bucket_name   = "moj-cur-reports"
  attach_policy = true
  policy        = data.aws_iam_policy_document.cur_reports_s3_bucket.json
}

data "aws_iam_policy_document" "cur_reports_s3_bucket" {
  version = "2008-10-17"

  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketPolicy",
      "s3:GetBucketAcl"
    ]
    resources = ["arn:aws:s3:::moj-cur-reports"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::386209384616:root"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::moj-cur-reports/*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::386209384616:root"]
    }
  }
}

# moj-cur-reports-quicksight
module "cur_reports_quicksight_s3_bucket" {
  source = "../../modules/s3"

  bucket_name   = "moj-cur-reports-quicksight"
  attach_policy = true
  policy        = data.aws_iam_policy_document.cur_reports_quicksight_s3_policy.json
}

data "aws_iam_policy_document" "cur_reports_quicksight_s3_policy" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketPolicy",
      "s3:GetBucketAcl"
    ]
    resources = ["arn:aws:s3:::moj-cur-reports-quicksight"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::386209384616:root"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::moj-cur-reports-quicksight/*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::386209384616:root"]
    }
  }
}
