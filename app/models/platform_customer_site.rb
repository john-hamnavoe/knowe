# frozen_string_literal: true

class PlatformCustomerSite < ApplicationRecord
  belongs_to :project
  belongs_to :platform_customer
  belongs_to :platform_company_outlet
  belongs_to :platform_location, optional: true
  belongs_to :platform_customer_site_state, optional: true
  belongs_to :platform_zone, optional: true

  has_many :platform_orders, -> { order(:order_number) }, dependent: :destroy
  has_many :platform_item_rentals, through: :platform_orders, dependent: :destroy
  has_many :platform_route_assignments, through: :platform_orders, dependent: :destroy
  accepts_nested_attributes_for :platform_orders
  accepts_nested_attributes_for :platform_location


  def as_platform_json
    site = { 
      "Name": name,
      "Reference": reference,
      "RelatedCustomerGuid": platform_customer.guid,
      "RelatedLocationInvoiceGuid": location_guid,
      "RelatedLocationGuid": location_guid,
      "CompanyOutletListItem": {
        "Guid": platform_company_outlet.guid
      },
      "CustomerSiteStateListItem": {
        "Guid": platform_customer_site_state.guid
      },
      "ZoneListItem": {
        "Guid": platform_zone.guid
      },
      "SiteTypeListItem": {},
      "SalesTerritoryListItem": {},    
      "RebatePaymentTypeListItem": {},
      "RebatePaymentTermListItem": {},
      "ReminderLetterPolicyListItem": {},
      "PaymentHandlingCodeListItem": {},
      "ContactMethods": {},
      "DocumentDeliveryMethods": [],
      "Areas": [],
      "AccessTimes": [],
      "RelatedTradingNames": [],
      "RelatedHealthAndSafetyBlobs": [] }
      
      site = site.merge({ "SICCodeListItem": {}, "VisitStatusListItem": {} }) if project.version.to_f >= 8.9
      
      site.to_json
  end
end


# "Name": "Galway Bins Delivery Account",
# "Reference": null,
# "SiteTypeListItem": null,
# "FederalId": null,
# "AnalysisCode": null,
# "RelatedCustomerGuid": "63bd63e0-9beb-43c9-a8a5-0056f82edc62",
# "UniqueCustomerSiteCode": null,
# "SICCodeListItem": null,
# "SalesTerritoryListItem": null,
# "CompanyOutletListItem": {
#   "Description": "Galway Office",
#   "Guid": "1a7cce04-df39-e911-85b3-00155d675d9a"
# },
# "CustomerSiteStateListItem": {
#   "Description": "Active",
#   "Guid": "127cce04-df39-e911-85b3-00155d675d9a"
# },
# "ZoneListItem": {
#   "Description": "HH Galway City Council",
#   "Guid": "858caf7b-37af-4c06-98dd-c6b985499a14"
# },
# "RebatePaymentTypeListItem": null,
# "RebatePaymentTermListItem": null,
# "ContactMethods": null,
# "PaymentHandlingCodeListItem": null,
# "ReminderLetterPolicyListItem": null,
# "DocumentDeliveryMethods": [],
# "RelatedLocationInvoiceGuid": "545ff178-ce2a-ed11-bd6e-281878863083",
# "RelatedLocationRemitGuid": "545ff178-ce2a-ed11-bd6e-281878863083",
# "RelatedLocationDocumentGuid": "545ff178-ce2a-ed11-bd6e-281878863083",
# "RelatedLocationStatementGuid": "545ff178-ce2a-ed11-bd6e-281878863083",
# "RelatedLocationQuotationGuid": "545ff178-ce2a-ed11-bd6e-281878863083",
# "RelatedLocationGuid": "545ff178-ce2a-ed11-bd6e-281878863083",
# "NumberOfUnits": null,
# "AccessTimes": [],
# "RelatedTradingNames": [],
# "RelatedHealthAndSafetyBlobs": [],
# "RelatedTradingNameGuidFilter": null,
# "Areas": [],
# "VisitStatusListItem": null,
# "AreasGuidFilter": null,
# "AreasRelatedLocationGuidFilter": null,
# "IsDeleted": false,
# "GUID": "792519cd-879d-443e-9457-41dc5d3cd3a0"
