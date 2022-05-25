# frozen_string_literal: true

class PlatformCustomerSite < ApplicationRecord
  belongs_to :project
  belongs_to :platform_customer
  belongs_to :platform_company_outlet
  belongs_to :platform_location, optional: true
  belongs_to :platform_customer_site_state, optional: true
  belongs_to :platform_zone, optional: true

  # has_many :platform_orders, -> { order(:order_number) }, dependent: :destroy
  # has_many :platform_item_rentals, through: :platform_orders, dependent: :destroy
  # has_many :platform_route_assignments, through: :platform_orders, dependent: :destroy
  # accepts_nested_attributes_for :platform_orders


  def as_platform_json
    { "Name": name,
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
      # "RebatePaymentTypeListItem": {},
      # "RebatePaymentTermListItem": {},
      # "ReminderLetterPolicyListItem": {},
      # "PaymentHandlingCodeListItem": {},
      # "ContactMethods": {},
      "DocumentDeliveryMethods": [],
      "Areas": [],
      "AccessTimes": [],
      "RelatedTradingNames": [],
      "RelatedHealthAndSafetyBlobs": [] }.to_json
  end
end

