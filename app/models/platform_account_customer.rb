# frozen_string_literal: true

class PlatformAccountCustomer < PlatformCustomer
  include AttributeJson
  accepts_nested_attributes_for :platform_customer_document_deliveries
    
  def as_platform_account_json(*attributes)
    if  attributes.any?
      customer = build_attributes_json(attributes)
    else 
      customer = { "Name": name,
                  "Reference": reference,
                  "IsInternal": is_internal,
                  "CombineChargesRebates": combine_charges_rebates,
                  "ReceiveServiceUpdatesByEmail": receive_service_updates_by_email,
                  "ReceiveServiceUpdatesByText": receive_service_updates_by_text,
                  "ReceiveMarketingUpdatesByEmail": receive_marketing_updates_by_email,
                  "ReceiveMarketingUpdatesByText": receive_marketing_updates_by_text,
                  "TicketsRequiredWithInvoice": false,
                  "ExternalVehicleValidation": false,
                  "ExcludeFromStatementRun": false,
                  "HasRedLight": false,
                  "RctCustomer": false,
                  "Notes": notes,
                  "ProofOfServiceRequired": false,
                  "RelatedLocationHQGuid": platform_customer_sites.first.location_guid,
                  "CompanyListItem": {
                    "Guid": platform_company.guid
                  },
                  "CustomerStateListItem": {
                    "Guid": platform_customer_state.guid
                  },
                  "CurrencyListItem": {
                    "Guid": platform_currency.guid
                  },
                  "CustomerTypeListItem": {
                    "Guid": platform_customer_type.guid
                  },
                  "CustomerTemplateListItem": {
                    "Guid": platform_customer_template.guid
                  },
                  "BusinessTypeListItem": {
                    "Guid": platform_business_type.guid
                  },
                  "CustomerCategoryListItem": {},
                  "CustomerGroupListItem": {},
                  "Contract": {
                    "StartDate": Time.zone.today,
                    "CreditLimit": credit_limit.to_f,
                    "IsInvoiceCollated": false,
                    "RollUpInvoiceBySite": false,
                    "RollUpInvoiceByService": false,
                    "InvoiceCycleListItem": {
                      "Guid": platform_invoice_cycle&.guid
                    },
                    "DepartmentListItem": {
                      "Guid": platform_department&.guid
                    },
                    "ContractStatusListItem": {
                      "Guid": platform_contract_status&.guid
                    },
                    "PaymentTypeListItem": {
                      "Guid": platform_payment_type&.guid
                    },
                    "PaymentTermListItem": {
                      "Guid": platform_payment_term&.guid
                    },
                    "InvoiceFrequencyTermListItem": {
                      "Guid": platform_invoice_frequency&.guid
                    },
                    "InvoiceDocumentDeliveryMethods": platform_customer_document_deliveries_as_json
                  },
                  "Balance": {},
                  "TradingNames": [],
                  "RelatedBlobHashes": [],
                  "RelatedReportBlobs": [],
                  "GUID": guid }

      customer = if guid.nil?
                  customer.merge({ "AutoArAccountCode": {
                                    "CompanyOutletGuid": platform_customer_sites.first.platform_company_outlet.guid
                                  } })
                else
                  customer.merge({
                                    "ARAccountCode": ar_account_code
                                  })
                end

      customer = customer.merge({ "BankDetails": platform_bank_details_as_json }) if platform_direct_debit_run_configuration.present?
    end

    customer.to_json
  end

  def platform_customer_document_deliveries_as_json
    document_deliveries = []
    platform_customer_document_deliveries.each do |document_delivery|
      platform_document_delivery = {
        "DocumentDeliveryType": {
          "Guid": document_delivery.platform_document_delivery_type.guid
        }
      }

      document_deliveries << platform_document_delivery
    end
    document_deliveries
  end

  def platform_bank_details_as_json 
    return nil if platform_direct_debit_run_configuration.nil?

    {
      "BankName": bank_name,
      "AccountName": bank_account_name,
      "AccountNo": bank_account_no,
      "SortCode": bank_sort_code,
      "BIC": bank_bic,
      "IBAN": bank_iban,
      "DirectDebitRunConfigListItem": {
        "Guid": platform_direct_debit_run_configuration.guid
      }
    }
  end  
end
