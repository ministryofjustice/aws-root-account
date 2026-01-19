resource "aws_guardduty_filter" "cloud_platform_trivy" {
  name        = "CloudPlatformTrivy"
  action      = "ARCHIVE"
  detector_id = local.guardduty_administrator_detector_ids.eu_west_2
  rank        = 1

  finding_criteria {
    criterion {
      field  = "accountId"
      equals = [local.cloud_platform_account_id]
    }
    criterion {
      field  = "region"
      equals = ["eu-west-2"]
    }
    criterion {
      field  = "resource.kubernetesDetails.kubernetesWorkloadDetails.namespace"
      equals = ["trivy-system"]
    }
  }
  tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })
}

resource "aws_guardduty_filter" "cloud_platform_eicr_txt" {
  name        = "EICARSuppression_txt"
  action      = "ARCHIVE"
  detector_id = local.guardduty_administrator_detector_ids.eu_west_2
  rank        = 2

  finding_criteria {
    criterion {
      field  = "accountId"
      equals = [local.cloud_platform_account_id]
    }
    criterion {
      field  = "region"
      equals = ["eu-west-2"]
    }
    criterion {
      field  = "service.ebsVolumeScanDetails.scanDetections.threatDetectedByName.threatNames.filePaths.hash"
      equals = ["275a021bbfb6489e54d471899f7db9d1663fc695ec2fe2a2c4538aabf651fd0f"]
    }
  }
  tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })
}

import {
  to = aws_guardduty_filter.cloud_platform_eicr_txt
  id = "${local.guardduty_administrator_detector_ids.eu_west_2}:EICARSuppression"
}

resource "aws_guardduty_filter" "cloud_platform_eicr_com" {
  name        = "EICARSuppression_com"
  action      = "ARCHIVE"
  detector_id = local.guardduty_administrator_detector_ids.eu_west_2
  rank        = 3

  finding_criteria {
    criterion {
      field  = "accountId"
      equals = [local.cloud_platform_account_id]
    }
    criterion {
      field  = "region"
      equals = ["eu-west-2"]
    }
    criterion {
      field  = "service.ebsVolumeScanDetails.scanDetections.threatDetectedByName.threatNames.filePaths.hash"
      equals = ["131f95c51cc819465fa1797f6ccacf9d494aaaff46fa3eac73ae63ffbdfd8267"]
    }
  }
  tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })
}

import {
  to = aws_guardduty_filter.cloud_platform_eicr_com
  id = "${local.guardduty_administrator_detector_ids.eu_west_2}:EICARSuppression_com"
}

resource "aws_guardduty_filter" "universal_eicar_supression_rule" {
  name        = "universal_eicar_supression_rule"
  action      = "ARCHIVE"
  detector_id = local.guardduty_administrator_detector_ids.eu_west_2
  rank        = 4

  finding_criteria {
    criterion {
      field  = "type"
      equals = ["Malware:S3Object"]
    }
    criterion {
      field   = "service.malwareScanDetails.threats.name"
      matches = ["EICAR-Test-File*"]
    }
  }
  tags = merge(
    local.tags_organisation_management, {
      component = "Security"
  })
}
