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
