class PlatformPrice < ApplicationRecord
  belongs_to :project
  belongs_to :platform_service_agreement
  belongs_to :platform_service, optional: true
  belongs_to :platform_action, optional: true
  belongs_to :platform_container_type, optional: true
  belongs_to :platform_material, optional: true
end
