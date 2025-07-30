resource "aws_backup_global_settings" "eu_west_1" {
  provider = aws.eu-west-1

  global_settings = {
    "isCrossAccountBackupEnabled" = "true"
    "isMpaEnabled"                = "false"
  }

  depends_on = [aws_organizations_organization.default]
}
