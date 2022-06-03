class PlatformOrderItem < ApplicationRecord
  belongs_to :project
  belongs_to :platform_order
  belongs_to :platform_container_type
  belongs_to :platform_container_status
  belongs_to :platform_container, optional: true

  has_many :platform_lift_events, dependent: :destroy

  accepts_nested_attributes_for :platform_lift_events, allow_destroy: true
end