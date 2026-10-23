### AWS policy ARN for existing service role

data "aws_iam_policy" "view_only_access" {
  arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/job-function/ViewOnlyAccess"
}

data "aws_iam_policy" "security_audit" {
  arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/SecurityAudit"
}


### Policy attachment

resource "aws_iam_role_policy_attachment" "view_only_access_role_policy_attach" {
  role       = aws_iam_role.user-role-tf.name
  policy_arn = data.aws_iam_policy.view_only_access.arn
}
resource "aws_iam_role_policy_attachment" "security_audit_role_policy_attach" {
  role       = aws_iam_role.user-role-tf.name
  policy_arn = data.aws_iam_policy.security_audit.arn
}
