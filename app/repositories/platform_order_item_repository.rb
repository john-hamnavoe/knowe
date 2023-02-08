# frozen_string_literal: true

class PlatformOrderItemRepository < ApplicationRepository
  def all(args={}, order_by="platform_order_id", direction="desc")
    query = PlatformOrderItem.where(project: project).where(args)

    query.order(order_by => direction)
  end

  def update(id, params)
    platform_order_item = PlatformOrderItem.find_by(id: id)
    return platform_order_item if platform_order_item.nil?

    @vehicles = PlatformVehicleRepository.new(user, project).all

    platform_order_item.assign_attributes(params)
    platform_order_item.platform_lift_events.each do |lift_event|
      lift_event.project = project if lift_event.project_id.nil?
      lift_event.charge_weight = lift_event.net_weight if lift_event.charge_weight.nil?
      lift_event.weight = lift_event.net_weight if lift_event.weight.nil?
      lift_event.tag = platform_order_item.tag if lift_event.tag.nil?
      lift_event.collection_time_stamp = lift_event.collection_date if lift_event.collection_time_stamp.nil?
      lift_event.related_site_order_container_guid = platform_order_item.guid if lift_event.related_site_order_container_guid.nil?
      lift_event.is_deleted = false if lift_event.is_deleted.nil?
      lift_event.is_collected = true if lift_event.is_collected.nil?

      lift_event.platform_vehicle_id = @vehicles.find { |v| v.registration_no == lift_event.vehicle_code ||  v.vehicle_code == lift_event.vehicle_code }&.id if lift_event.platform_vehicle_id.nil?
    end
    platform_order_item.save
    PlatformPostRepository.new(user, project).update_row_count("PlatformLiftEvent")
    platform_order_item
  end

  def import(records)
    PlatformOrderItem.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:platform_order_id, :platform_container_type_id, :is_deleted,
                                                                                                                  :related_container_guid, :platform_container_status_id] }, returning: :guid
  end
end
