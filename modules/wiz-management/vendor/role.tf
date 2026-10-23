resource "aws_iam_role" "user-role-tf" {
  name                 = var.rolename
  path                 = var.role_path
  permissions_boundary = var.permission_boundary_arn

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : var.remote-arn
          },
          "Action" : "sts:AssumeRole",
          "Condition" : {
            "StringEquals" : {
              "sts:ExternalId" : var.external-id
            }
          }
        }
      ]
    }
  )
  tags = merge(
    var.tags,
    local.wiz_version_last_updated
  )
}

locals {
  wiz_role_name = aws_iam_role.user-role-tf.name
}
