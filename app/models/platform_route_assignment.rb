class PlatformRouteAssignment < ApplicationRecord
  belongs_to :project
  belongs_to :platform_order

  belongs_to :platform_action, optional: true
  belongs_to :platform_pickup_interval, optional: true
  belongs_to :platform_day_of_week, optional: true
  belongs_to :platform_container_type, optional: true
  belongs_to :platform_route_template, optional: true
end
