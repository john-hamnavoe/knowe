class PlatformBookmark < ApplicationRecord
  CUSTOMER = "PlatformCustomer".freeze
  CUSTOMER_SITE = "PlatformCutomerSite".freeze
  LOCATION = "PlatformLocation".freeze
  ORDER = "PlatformOrder".freeze
  SERVICE_AGREEMENT = "PlatformServiceAgreement".freeze
  ROUTE_TEMPLATE = "PlatformRouteTemplate".freeze
    
  belongs_to :project
end
