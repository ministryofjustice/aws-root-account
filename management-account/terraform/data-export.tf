resource "aws_bcmdataexports_export" "moj_cur_v2_report" {
  export {
    name = "MOJ-CUR-V2-HOURLY"
    data_query {
      query_statement = <<-EOF
        SELECT 
          bill_bill_type, bill_billing_entity, bill_billing_period_end_date, bill_billing_period_start_date, 
          bill_invoice_id, bill_invoicing_entity, bill_payer_account_id, bill_payer_account_name, 
          cost_category, discount, discount_bundled_discount, discount_total_discount, 
          identity_line_item_id, identity_time_interval, 
          line_item_availability_zone, line_item_blended_cost, line_item_blended_rate, line_item_currency_code, 
          line_item_legal_entity, line_item_line_item_description, line_item_line_item_type, 
          line_item_net_unblended_cost, line_item_net_unblended_rate, line_item_normalization_factor, 
          line_item_normalized_usage_amount, line_item_operation, line_item_product_code, line_item_resource_id, 
          line_item_tax_type, line_item_unblended_cost, line_item_unblended_rate, line_item_usage_account_id, 
          line_item_usage_account_name, line_item_usage_amount, line_item_usage_end_date, line_item_usage_start_date, 
          line_item_usage_type, pricing_currency, pricing_lease_contract_length, pricing_offering_class, 
          pricing_public_on_demand_cost, pricing_public_on_demand_rate, pricing_purchase_option, pricing_rate_code, 
          pricing_rate_id, pricing_term, pricing_unit, product, product_comment, product_fee_code, 
          product_fee_description, product_from_location, product_from_location_type, product_from_region_code, 
          product_instance_family, product_instance_type, product_instancesku, product_location, 
          product_location_type, product_operation, product_pricing_unit, product_product_family, 
          product_region_code, product_servicecode, product_sku, product_to_location, product_to_location_type, 
          product_to_region_code, product_usagetype, 
          reservation_amortized_upfront_cost_for_usage, reservation_amortized_upfront_fee_for_billing_period, 
          reservation_availability_zone, reservation_effective_cost, reservation_end_time, 
          reservation_modification_status, reservation_net_amortized_upfront_cost_for_usage, 
          reservation_net_amortized_upfront_fee_for_billing_period, reservation_net_effective_cost, 
          reservation_net_recurring_fee_for_usage, reservation_net_unused_amortized_upfront_fee_for_billing_period, 
          reservation_net_unused_recurring_fee, reservation_net_upfront_value, reservation_normalized_units_per_reservation, 
          reservation_number_of_reservations, reservation_recurring_fee_for_usage, reservation_reservation_a_r_n, 
          reservation_start_time, reservation_subscription_id, reservation_total_reserved_normalized_units, 
          reservation_total_reserved_units, reservation_units_per_reservation, reservation_unused_amortized_upfront_fee_for_billing_period, 
          reservation_unused_normalized_unit_quantity, reservation_unused_quantity, reservation_unused_recurring_fee, 
          reservation_upfront_value, resource_tags, 
          savings_plan_amortized_upfront_commitment_for_billing_period, savings_plan_end_time, 
          savings_plan_instance_type_family, savings_plan_net_amortized_upfront_commitment_for_billing_period, 
          savings_plan_net_recurring_commitment_for_billing_period, savings_plan_net_savings_plan_effective_cost, 
          savings_plan_offering_type, savings_plan_payment_option, savings_plan_purchase_term, 
          savings_plan_recurring_commitment_for_billing_period, savings_plan_region, savings_plan_savings_plan_a_r_n, 
          savings_plan_savings_plan_effective_cost, savings_plan_savings_plan_rate, savings_plan_start_time, 
          savings_plan_total_commitment_to_date, savings_plan_used_commitment, 
          split_line_item_actual_usage,  split_line_item_net_split_cost, 
          split_line_item_net_unused_cost,  split_line_item_parent_resource_id, split_line_item_public_on_demand_split_cost, 
          split_line_item_public_on_demand_unused_cost, split_line_item_reserved_usage, split_line_item_split_cost , split_line_item_split_usage, 
          split_line_item_split_usage_ratio, split_line_item_unused_cost 
        FROM COST_AND_USAGE_REPORT
      EOF
      table_configurations = {
        COST_AND_USAGE_REPORT = {
          TIME_GRANULARITY                      = "HOURLY",
          INCLUDE_RESOURCES                     = "TRUE",
          INCLUDE_MANUAL_DISCOUNT_COMPATIBILITY = "FALSE",
          INCLUDE_SPLIT_COST_ALLOCATION_DATA    = "TRUE",
        }
      }
    }
    destination_configurations {
      s3_destination {
        s3_bucket = module.cur_reports_v2_hourly_s3_bucket.s3_bucket_id
        s3_prefix = "moj-cost-and-usage-reports"
        s3_region = "eu-west-2"
        s3_output_configurations {
          overwrite   = "OVERWRITE_REPORT"
          format      = "PARQUET"
          compression = "PARQUET"
          output_type = "CUSTOM"
        }
      }
    }
    refresh_cadence {
      frequency = "SYNCHRONOUS"
    }
  }
}

resource "aws_bcmdataexports_export" "focus_report" {
  export {
    name = "MOJ-FOCUS"
    data_query {
      query_statement = <<-EOF
        SELECT AvailabilityZone, BilledCost, BillingAccountId, BillingAccountName, BillingCurrency, BillingPeriodEnd, 
        BillingPeriodStart, ChargeCategory, ChargeClass, ChargeDescription, ChargeFrequency, ChargePeriodEnd, ChargePeriodStart, 
        CommitmentDiscountCategory, CommitmentDiscountId, CommitmentDiscountName, CommitmentDiscountStatus, CommitmentDiscountType, 
        ConsumedQuantity, ConsumedUnit, ContractedCost, ContractedUnitPrice, EffectiveCost, InvoiceIssuerName, ListCost, ListUnitPrice, 
        PricingCategory, PricingQuantity, PricingUnit, ProviderName, PublisherName, RegionId, RegionName, ResourceId, ResourceName, 
        ResourceType, ServiceCategory, ServiceName, SkuId, SkuPriceId, SubAccountId, SubAccountName, Tags, x_CostCategories, x_Discounts, 
        x_Operation, x_ServiceCode, x_UsageType FROM FOCUS_1_0_AWS
      EOF
      table_configurations = {
        FOCUS_1_0_AWS = {}
      }
    }
    destination_configurations {
      s3_destination {
        s3_bucket = module.focus_reports_s3_bucket.bucket.bucket
        s3_prefix = "moj-focus-reports"
        s3_region = "eu-west-2"
        s3_output_configurations {
          overwrite   = "OVERWRITE_REPORT"
          format      = "PARQUET"
          compression = "PARQUET"
          output_type = "CUSTOM"
        }
      }
    }
    refresh_cadence {
      frequency = "SYNCHRONOUS"
    }
  }
}