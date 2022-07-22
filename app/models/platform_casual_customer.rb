# frozen_string_literal: true

class PlatformCasualCustomer < PlatformCustomer
   def as_platform_json
    { "Name": name,
      "Reference": reference,
      "IsInternal": is_internal,
      "ReceiveServiceUpdatesByEmail": receive_service_updates_by_email,
      "ReceiveServiceUpdatesByText": receive_service_updates_by_text,
      "ReceiveMarketingUpdatesByEmail": receive_marketing_updates_by_email,
      "ReceiveMarketingUpdatesByText": receive_marketing_updates_by_text,
      "CompanyListItem": {
        "Guid": platform_company.guid
      },
      "CustomerStateListItem": {
        "Guid": platform_customer_state.guid
      },
      "CurrencyListItem": {
        "Guid": platform_currency.guid
      },
      "RelatedBlobHashes": [],
      "RelatedReportBlobs": [],
      "GUID": guid }.to_json
  end
end
