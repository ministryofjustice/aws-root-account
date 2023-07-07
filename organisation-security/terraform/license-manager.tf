# Windows licensing
resource "aws_licensemanager_license_configuration" "windows_server_datacenter_2019" {
  name                     = "Windows Server Datacenter 2019 (EC2 and on-premises)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

# Oracle licensing
resource "aws_licensemanager_license_configuration" "oracle_tuning_pack_for_sqlt" {
  name                     = "Oracle Database Tuning Pack for SQLT (Amazon RDS)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

resource "aws_licensemanager_license_configuration" "oracle_diagnostic_pack_sqlt" {
  name                     = "Oracle Database Diagnostic Pack for SQLT (Amazon RDS)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

resource "aws_licensemanager_license_configuration" "oracle_olap" {
  name                     = "Oracle Database Oracle On-Line Analytical Processing (OLAP) (Amazon RDS)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

resource "aws_licensemanager_license_configuration" "oracle_label_security" {
  name                     = "Oracle Database Label Security (Amazon RDS)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

resource "aws_licensemanager_license_configuration" "oracle_adg" {
  name                     = "Oracle Database Active Data Guard (Amazon RDS)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

resource "aws_licensemanager_license_configuration" "oracle_se" {
  name                     = "Oracle Database Standard Edition (Amazon RDS)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

resource "aws_licensemanager_license_configuration" "oracle_se1" {
  name                     = "Oracle Database Standard Edition One (Amazon RDS)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

resource "aws_licensemanager_license_configuration" "oracle_se2" {
  name                     = "Oracle Database Standard Edition Two (Amazon RDS)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}

resource "aws_licensemanager_license_configuration" "oracle_ee" {
  name                     = "Oracle Database Enterprise Edition (Amazon RDS)"
  license_count            = 0
  license_count_hard_limit = false
  license_counting_type    = "vCPU"
}
