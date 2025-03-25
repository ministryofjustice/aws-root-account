########################################
# S3 account-level public access block #
########################################

resource "aws_s3_account_public_access_block" "default" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

##############
# S3 buckets #
##############

# AWS Config log bucket
module "config_log_bucket" {
  source = "../../modules/config-bucket"
}

# cloudtrail--replication20210315101340520100000002
module "cloudtrail_replication_s3_bucket" {
  providers = {
    aws = aws.eu-west-1
  }
  source           = "../../modules/s3"
  object_ownership = "ObjectWriter"
  bucket_name      = "cloudtrail--replication20210315101340520100000002"

  attach_policy        = true
  require_ssl_requests = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = module.cloudtrail.kms_key_arn
      }
    }
  }
}

# cloudtrail-20210315101356188000000003
module "cloudtrail_s3_bucket" {
  source = "../../modules/s3"

  bucket_name      = "cloudtrail-20210315101356188000000003"
  bucket_acl       = "log-delivery-write"
  object_ownership = "ObjectWriter"

  attach_policy        = true
  policy               = data.aws_iam_policy_document.cloudtrail_s3_bucket.json
  require_ssl_requests = true

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

  bucket_name = "log-bucket-replication20210315101330747900000001"

  attach_policy        = true
  require_ssl_requests = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "aws:kms"
      }
    }
  }
}

# log-bucket20210315101344444500000002
module "log_bucket_s3_bucket" {
  source = "../../modules/s3"

  bucket_name = "log-bucket20210315101344444500000002"

  attach_policy        = true
  require_ssl_requests = true
  object_ownership     = "ObjectWriter"

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "aws:kms"
      }
    }
  }
}

# moj-aws-root-account-terraform-state
module "terraform_state_s3_bucket" {
  source = "../../modules/s3"

  bucket_name = "moj-aws-root-account-terraform-state"

  attach_policy = true
  policy        = data.aws_iam_policy_document.terraform_state_s3_bucket.json
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = resource.aws_kms_key.terraform_state_s3_bucket.id
      }
    }
  }
}

data "aws_iam_policy_document" "terraform_state_s3_bucket" {
  statement {
    sid    = "AllowReadAccessFromSecurityAccount"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetObject"
    ]
    resources = [
      module.terraform_state_s3_bucket.bucket.arn,
      "${module.terraform_state_s3_bucket.bucket.arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${resource.aws_organizations_account.organisation_security.id}:root"]
    }
  }

  statement {
    sid    = "AllowAccessFromSecurityAccount"
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = ["${module.terraform_state_s3_bucket.bucket.arn}/organisation-security/*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${resource.aws_organizations_account.organisation_security.id}:root"]
    }
  }
}

# moj-cur-reports
module "cur_reports_s3_bucket" {
  source = "../../modules/s3"

  bucket_name            = "moj-cur-reports"
  attach_policy          = true
  policy                 = data.aws_iam_policy_document.cur_reports_s3_bucket.json
  enable_replication     = true
  replication_bucket_arn = "arn:aws:s3:::moj-cur-reports-modplatform-20241021144023194000000001"
  replication_role_arn   = module.cur_reports_s3_bucket.replication_role_arn
  source_kms_arn         = data.aws_kms_alias.moj_cur_reports_kms_alias.target_key_arn
  destination_kms_arn    = data.aws_ssm_parameter.core_logging_kms_key_arn.value
  replication_rules = [
    {
      id                 = "replicate-cur-athena"
      prefix             = "CUR-ATHENA/"
      status             = "Enabled"
      deletemarker       = "Enabled"
      replica_kms_key_id = data.aws_ssm_parameter.core_logging_kms_key_arn.value
      metrics            = "Enabled"
    }
  ]
}

data "aws_ssm_parameter" "core_logging_kms_key_arn" {
  name = "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.current.account_id}:parameter/core-logging-kms-key"
}

data "aws_kms_alias" "moj_cur_reports_kms_alias" {
  name = "alias/aws/s3"
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

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectTagging",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::moj-cur-reports",
      "arn:aws:s3:::moj-cur-reports/*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::083957762049:root"]
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

# moj-cur-reports-greenops
module "cur_reports_v2_hourly_s3_bucket" {
  source = "github.com/ministryofjustice/modernisation-platform-terraform-s3-bucket?ref=52a40b0dd18aaef0d7c5565d93cc8997aad79636" # v8.2.0"
  providers = {
    aws.bucket-replication = aws
  }
  bucket_name        = "moj-cur-reports-v2-hourly"
  bucket_policy      = [data.aws_iam_policy_document.cur_reports_v2_hourly_s3_policy.json]
  ownership_controls = "BucketOwnerEnforced"

  tags = {
    business-unit = "Platforms"
    application   = "Modernisation Platform"
    is-production = true
    owner         = "Modernisation Platform: modernisation-platform@digital.justice.gov.uk"
  }
}

data "aws_iam_policy_document" "cur_reports_v2_hourly_s3_policy" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketPolicy",
      "s3:GetBucketAcl"
    ]
    resources = ["arn:aws:s3:::moj-cur-reports-v2-hourly"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::386209384616:root"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::moj-cur-reports-v2-hourly/*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::386209384616:root"]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::moj-cur-reports-v2-hourly",
      "arn:aws:s3:::moj-cur-reports-v2-hourly/*"
    ]
    principals {
      type        = "Service"
      identifiers = ["bcm-data-exports.amazonaws.com"]
    }

  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::moj-cur-reports-v2-hourly",
      "arn:aws:s3:::moj-cur-reports-v2-hourly/*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::211125434264:root"]
    }
  }
}