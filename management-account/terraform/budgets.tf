##############
# Everything #
##############
resource "aws_budgets_budget" "everything" {
  name              = "Everything"
  account_id        = data.aws_caller_identity.current.account_id
  budget_type       = "COST"
  time_unit         = "MONTHLY"
  time_period_start = "2021-06-01_00:00"
  time_period_end   = "2087-06-15_00:00"
  limit_amount      = "1100000.0"
  limit_unit        = "USD"

  cost_types {
    include_credit             = true
    include_discount           = true
    include_other_subscription = true
    include_recurring          = true
    include_refund             = true
    include_subscription       = true
    include_support            = true
    include_tax                = true
    include_upfront            = true
    use_amortized              = false
    use_blended                = false
  }
}

################
# HMPPS Delius #
################
resource "aws_budgets_budget" "hmpps_delius" {
  name              = "HMPPS Delius"
  account_id        = data.aws_caller_identity.current.account_id
  budget_type       = "COST"
  time_unit         = "MONTHLY"
  time_period_start = "2021-08-01_00:00"
  time_period_end   = "2087-06-15_00:00"
  limit_amount      = "425000.0"
  limit_unit        = "USD"

  cost_filter {
    name = "LinkedAccount"
    values = [
      aws_organizations_account.alfresco_non_prod.id,
      aws_organizations_account.delius_core_non_prod.id,
      aws_organizations_account.hmpps_cr_jira_production.id,
      aws_organizations_account.hmpps_cr_unpaid_work_non_production.id,
      aws_organizations_account.hmpps_cr_unpaid_work_production.id,
      aws_organizations_account.hmpps_delius_mis_non_prod.id,
      aws_organizations_account.hmpps_delius_pre_production.id,
      aws_organizations_account.hmpps_delius_stage.id,
      aws_organizations_account.hmpps_delius_test.id,
      aws_organizations_account.hmpps_delius_training.id,
      aws_organizations_account.hmpps_engineering_production.id,
      aws_organizations_account.hmpps_probation_production.id,
      aws_organizations_account.hmpps_victim_case_management_system_pre_production.id,
      aws_organizations_account.hmpps_victim_case_management_system_production.id,
      aws_organizations_account.hmpps_victim_case_management_system_test.id,
      aws_organizations_account.probation.id,
      aws_organizations_account.probation_management_non_prod.id,
      aws_organizations_account.vcms_non_prod.id,
    ]
  }

  cost_types {
    include_credit             = false
    include_discount           = false
    include_other_subscription = false
    include_recurring          = false
    include_refund             = false
    include_subscription       = true
    include_support            = false
    include_tax                = false
    include_upfront            = false
    use_amortized              = false
    use_blended                = false
  }
}

#######
# LAA #
#######
resource "aws_budgets_budget" "laa" {
  name              = "LAA"
  account_id        = data.aws_caller_identity.current.account_id
  budget_type       = "COST"
  time_unit         = "MONTHLY"
  time_period_start = "2021-06-01_00:00"
  time_period_end   = "2087-06-15_00:00"
  limit_amount      = "115000.0"
  limit_unit        = "USD"

  cost_filter {
    name = "LinkedAccount"
    values = [
      aws_organizations_account.laa_cloudtrail.id,
      aws_organizations_account.laa_development.id,
      aws_organizations_account.laa_production.id,
      aws_organizations_account.laa_shared_services.id,
      aws_organizations_account.laa_staging.id,
      aws_organizations_account.laa_test.id,
      aws_organizations_account.laa_uat.id,
      aws_organizations_account.legal_aid_agency.id,
    ]
  }

  cost_types {
    include_credit             = true
    include_discount           = true
    include_other_subscription = true
    include_recurring          = true
    include_refund             = true
    include_subscription       = true
    include_support            = true
    include_tax                = true
    include_upfront            = true
    use_amortized              = false
    use_blended                = false
  }
}

#######################
# Youth Justice Board #
#######################
resource "aws_budgets_budget" "youth_justice_board" {
  name              = "Youth Justice Board"
  account_id        = data.aws_caller_identity.current.account_id
  budget_type       = "COST"
  time_unit         = "MONTHLY"
  time_period_start = "2021-06-01_00:00"
  time_period_end   = "2087-06-15_00:00"
  limit_amount      = "25000.0"
  limit_unit        = "USD"

  cost_filter {
    name = "LinkedAccount"
    values = [
      aws_organizations_account.youth_justice_framework_dev.id,
      aws_organizations_account.youth_justice_framework_eng_tools.id,
      aws_organizations_account.youth_justice_framework_juniper.id,
      aws_organizations_account.youth_justice_framework_management.id,
      aws_organizations_account.youth_justice_framework_monitoring.id,
      aws_organizations_account.youth_justice_framework_pre_prod.id,
      aws_organizations_account.youth_justice_framework_prod.id,
      aws_organizations_account.youth_justice_framework_sandpit.id,
    ]
  }

  cost_types {
    include_credit             = true
    include_discount           = true
    include_other_subscription = true
    include_recurring          = true
    include_refund             = true
    include_subscription       = true
    include_support            = true
    include_tax                = true
    include_upfront            = true
    use_amortized              = false
    use_blended                = false
  }
}
