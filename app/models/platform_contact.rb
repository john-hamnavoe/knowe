# frozen_string_literal: true

class PlatformContact < ApplicationRecord
  belongs_to :project
  belongs_to :platform_contact_type, optional: true
  belongs_to :platform_customer

  def as_platform_json
    contact = { "Forename": forename,
                "Surname": surname,
                "JobTitle": nil,
                "ActivationCode": nil,
                "RelatedCustomerGuid": platform_customer.guid,
                "RelatedLocationGuids": [],
                "ContactMethods": {
                  "TelNo": tel_no,
                  "OtherTelNo": nil,
                  "Email": email
                },
                "ContactRegistrationStatusListItem": nil,
                "AccessGroupListItem": nil,
                "PinCode": nil,
                "ContactPassword": nil,
                "ConfirmContactPassword": nil,
                "ContactTypeListItems": [
                  {
                    "ContactTypeListItem": {
                      "Guid": platform_contact_type.guid
                    }
                  }
                ],
                "GUID": guid }

    contact = if platform_customer.platform_customer_sites.count.zero?
                contact.merge({ "RelatedLocationGuid": nil })
              else
                contact.merge({ "RelatedLocationGuids": [{ "RelatedLocationGuid": platform_customer.platform_customer_sites.first.location_guid,
                                                           "IsPrimary": true }] })
              end

    contact.to_json
  end
end
