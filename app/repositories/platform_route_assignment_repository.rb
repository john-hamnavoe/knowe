# frozen_string_literal: true

class PlatformRouteAssignmentRepository < ApplicationRepository
  def import(records)
    PlatformRouteAssignment.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:platform_order_id, :position, :platform_action_id, :platform_container_type_id, :platform_route_template_id,
                                                                                                                                          :platform_day_of_week_id, :platform_pickup_interval_id, :start_date] }, returning: :guid
  end
end
