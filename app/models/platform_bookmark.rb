class PlatformBookmark < ApplicationRecord
  CONTACT = "PlatformContact".freeze
  CUSTOMER = "PlatformCustomer".freeze
  CUSTOMER_SITE = "PlatformCutomerSite".freeze
  LIFT_EVENT = "PlatformLiftEvent".freeze
  LOCATION = "PlatformLocation".freeze
  ORDER = "PlatformOrder".freeze
  SERVICE_AGREEMENT = "PlatformServiceAgreement".freeze
  ROUTE_TEMPLATE = "PlatformRouteTemplate".freeze

  belongs_to :project
end
