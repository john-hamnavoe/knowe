class PlatformOrderItem < ApplicationRecord
  belongs_to :project
  belongs_to :platform_order
  belongs_to :platform_container_type
  belongs_to :platform_container_status

  has_many :platform_lift_events, dependent: :destroy
end