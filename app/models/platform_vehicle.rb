class PlatformVehicle < ApplicationRecord
  belongs_to :project
  belongs_to :platform_company_outlet, optional: true
  belongs_to :platform_vehicle_type, optional: true
end
