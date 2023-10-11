output "guardduty_administrator_detector_ids" {
  description = "Guardduty detector IDs for the organisation security account"
  value = {
    "us_east_1"      = module.guardduty_us_east_1.administrator_detector_id
    "us_east_2"      = module.guardduty_us_east_2.administrator_detector_id
    "us_west_1"      = module.guardduty_us_west_1.administrator_detector_id
    "us_west_2"      = module.guardduty_us_west_2.administrator_detector_id
    "ap_south_1"     = module.guardduty_ap_south_1.administrator_detector_id
    "ap_northeast_1" = module.guardduty_ap_northeast_1.administrator_detector_id
    "ap_northeast_2" = module.guardduty_ap_northeast_2.administrator_detector_id
    "ap_northeast_3" = module.guardduty_ap_northeast_3.administrator_detector_id
    "ap_southeast_1" = module.guardduty_ap_southeast_1.administrator_detector_id
    "ap_southeast_2" = module.guardduty_ap_southeast_2.administrator_detector_id
    "ca_central_1"   = module.guardduty_ca_central_1.administrator_detector_id
    "eu_central_1"   = module.guardduty_eu_central_1.administrator_detector_id
    "eu_west_1"      = module.guardduty_eu_west_1.administrator_detector_id
    "eu_west_2"      = module.guardduty_eu_west_2.administrator_detector_id
    "eu_west_3"      = module.guardduty_eu_west_3.administrator_detector_id
    "eu_north_1"     = module.guardduty_eu_north_1.administrator_detector_id
    "sa_east_1"      = module.guardduty_sa_east_1.administrator_detector_id
  }
}

output "organizations_organization" {
  value = aws_organizations_organization.default
}
