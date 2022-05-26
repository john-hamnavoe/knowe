class PlatformItemRental < ApplicationRecord
  belongs_to :project
  belongs_to :platform_order

  belongs_to :platform_price, optional: true
  belongs_to :platform_action, optional: true
  belongs_to :platform_container_type, optional: true
end
