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

module "focus_s3_kms" {
  #checkov:skip=CKV_TF_1:Module registry does not support commit hashes for versions
  #checkov:skip=CKV_TF_2:Module registry does not support tags for versions

  source  = "terraform-aws-modules/kms/aws"
  version = "3.1.1"

  aliases               = ["s3/focus"]
  description           = "S3 FOCUS KMS key"
  enable_default_policy = true

  deletion_window_in_days = 7

  tags = local.tags
}