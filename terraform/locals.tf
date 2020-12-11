data "aws_caller_identity" "current" {}

locals {
  root_account = {
    business-unit = "Platforms"
    application   = "AWS root account"
    is-production = true
    owner         = "Hosting Leads: hosting-leads@digital.justice.gov.uk"
  }
  caller_identity   = data.aws_caller_identity.current
  github_repository = "github.com/ministryofjustice/aws-root-account/blob/main/terraform"
}
