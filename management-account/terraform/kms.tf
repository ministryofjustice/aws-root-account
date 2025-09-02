# State bucket key

resource "aws_kms_key" "terraform_state_s3_bucket" {
  policy              = data.aws_iam_policy_document.terraform_state_s3_bucket_kms.json
  is_enabled          = true
  enable_key_rotation = true
}

resource "aws_kms_alias" "terraform_state_s3_bucket" {
  name          = "alias/terraform-state-s3-bucket"
  target_key_id = aws_kms_key.terraform_state_s3_bucket.id
}

data "aws_iam_policy_document" "terraform_state_s3_bucket_kms" {
  statement {
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt"
    ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${resource.aws_organizations_account.organisation_security.id}:root"]
    }
  }
}

# FOCUS bucket key

module "focus_s3_kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "4.1.0"

  aliases                 = ["s3/focus"]
  description             = "FOCUS S3 bucket KMS key"
  enable_default_policy   = true
  deletion_window_in_days = 7
}

# CUR v2 bucket key

module "cur_v2_s3_kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "4.1.0"

  aliases                 = ["s3/curv2"]
  description             = "CUR v2 S3 bucket KMS key"
  enable_default_policy   = true
  deletion_window_in_days = 7
}
