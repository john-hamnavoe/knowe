class PlatformLiftEvent < ApplicationRecord
  belongs_to :project
  belongs_to :platform_order_item, optional: true
end
