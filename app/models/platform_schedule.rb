class PlatformSchedule < ApplicationRecord
  belongs_to :project
  belongs_to :platform_company_outlet
  belongs_to :platform_vehicle, optional: true
end
