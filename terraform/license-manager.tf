# Windows licensing
resource "aws_licensemanager_license_configuration" "windows-server-datacenter-2019" {
  provider = aws.organisation-security-eu-west-2

  name                     = "Windows Server Datacenter 2019 (EC2 and on-premises)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

# Oracle licensing
resource "aws_licensemanager_license_configuration" "oracle-tuning-pack-for-sqlt" {
  provider = aws.organisation-security-eu-west-2

  name                     = "Oracle Database Tuning Pack for SQLT (Amazon RDS)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

resource "aws_licensemanager_license_configuration" "oracle-diagnostic-pack-sqlt" {
  provider = aws.organisation-security-eu-west-2

  name                     = "Oracle Database Diagnostic Pack for SQLT (Amazon RDS)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

resource "aws_licensemanager_license_configuration" "oracle-olap" {
  provider = aws.organisation-security-eu-west-2

  name                     = "Oracle Database Oracle On-Line Analytical Processing (OLAP) (Amazon RDS)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

resource "aws_licensemanager_license_configuration" "oracle-label-security" {
  provider = aws.organisation-security-eu-west-2

  name                     = "Oracle Database Label Security (Amazon RDS)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

resource "aws_licensemanager_license_configuration" "oracle-adg" {
  provider = aws.organisation-security-eu-west-2

  name                     = "Oracle Database Active Data Guard (Amazon RDS)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

resource "aws_licensemanager_license_configuration" "oracle-se" {
  provider = aws.organisation-security-eu-west-2

  name                     = "Oracle Database Standard Edition (Amazon RDS)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

resource "aws_licensemanager_license_configuration" "oracle-se1" {
  provider = aws.organisation-security-eu-west-2

  name                     = "Oracle Database Standard Edition One (Amazon RDS)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

resource "aws_licensemanager_license_configuration" "oracle-se2" {
  provider = aws.organisation-security-eu-west-2

  name                     = "Oracle Database Standard Edition Two (Amazon RDS)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

resource "aws_licensemanager_license_configuration" "oracle-ee" {
  provider = aws.organisation-security-eu-west-2

  name                     = "Oracle Database Enterprise Edition (Amazon RDS)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}
