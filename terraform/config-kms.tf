##############################
# KMS key for the SNS topic  #
# for AWS Config             #
##############################
data "aws_iam_policy_document" "config-kms-key-policy" {
  statement {
    sid       = "Allow Config to use the key"
    effect    = "Allow"
    actions   = ["kms:GenerateDataKey"]
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }

  # You also need to explicitly allow accounts to update and manage the key, otherwise
  # it becomes unmanageable
  # See: https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html#key-policy-default
  statement {
    sid       = "Allow key management"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${local.caller_identity.id}:root",                          # Allow the root account to manage this key
        "arn:aws:iam::${aws_organizations_account.organisation-security.id}:root" # Allow the organisation-security account to manage this key
      ]
    }
  }
}

resource "aws_kms_key" "config" {
  # Set the provider to organisation-security, as that's where we manage Config aggregation
  provider = aws.organisation-security-eu-west-2

  description             = "KMS key for AWS Config to encrypt SNS topic notifications"
  deletion_window_in_days = 30
  is_enabled              = true
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.config-kms-key-policy.json

  tags = merge(
    local.tags-organisation-management, {
      component = "Security"
    }
  )
}
