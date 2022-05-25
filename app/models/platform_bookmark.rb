class PlatformBookmark < ApplicationRecord
  CUSTOMER = "PlatformCustomer".freeze
  CUSTOMER_SITE = "PlatformCutomerSite".freeze
  ORDER = "PlatformOrder".freeze
  SERVICE_AGREEMENT = "PlatformServiceAgreement".freeze
  ROUTE_TEMPLATE = "PlatformRouteTemplate".freeze
    
  belongs_to :project
end
