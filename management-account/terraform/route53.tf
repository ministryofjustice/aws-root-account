###########
# Route53 #
###########

resource "aws_route53_zone" "access_platforms_service_justice_gov_uk" {
  name = "access.platforms.service.justice.gov.uk"
}
