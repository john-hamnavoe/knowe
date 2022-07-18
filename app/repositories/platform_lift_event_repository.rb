# frozen_string_literal: true

class PlatformLiftEventRepository < ApplicationRepository
  def all(args = {}, order_by = "collection_date", direction = "asc")
    query = PlatformLiftEvent.includes(:platform_vehicle).where(project: project).where(args)

    query.order(order_by => direction)
  end

  def all_group_by_month(args = {})
    query = PlatformLiftEvent.joins(platform_order_item: { platform_order: :platform_material }).where(project: project).where(args)
    query.group("platform_materials.description").group_by_month(:collection_date).sum(:net_weight)
  end

  def load(id)
    PlatformLiftEvent.find_by(id: id,  project: project)
  end

  def load_by_guid(guid)
    PlatformLiftEvent.find_by(guid: guid,  project: project)
  end

  def import(records)
    PlatformLiftEvent.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:platform_order_item_id, :charge_weight, :net_weight, :weight, :quantity_collected,
                                                                                                                  :vehicle_code, :lift_text, :problem_text, :tag, :collection_date, :information_text,
                                                                                                                  :collection_time_stamp, :related_route_guid, :related_route_visit_guid, :related_site_order_container_guid,
                                                                                                                  :is_deleted, :is_collected, :latitude, :longitude] }, returning: :guid
  end
end
