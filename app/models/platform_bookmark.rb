class PlatformBookmark < ApplicationRecord
  CONTACT = "PlatformContact".freeze
  CONTAINER = "PlatformContainer".freeze  
  CUSTOMER_ACCOUNT = "PlatformAccountCustomer".freeze
  CUSTOMER_CASUAL = "PlatformCasualCustomer".freeze
  CUSTOMER_SITE = "PlatformCutomerSite".freeze
  LIFT_EVENT = "PlatformLiftEvent".freeze
  LOCATION = "PlatformLocation".freeze
  ORDER = "PlatformOrder".freeze
  SERVICE_AGREEMENT = "PlatformServiceAgreement".freeze
  ROUTE_TEMPLATE = "PlatformRouteTemplate".freeze
  SCHEDULE = "PlatformSchedule".freeze
  JOB = "PlatformJob".freeze

  belongs_to :project
end
