class PlatformCustomerDocumentDelivery < ApplicationRecord
  belongs_to :platform_customer
  belongs_to :platform_document_delivery_type
end
