# frozen_string_literal: true

class PlatformOrderItemRepository < ApplicationRepository
  def all(args={}, order_by="platform_order_id", direction="desc")
    query = PlatformOrderItem.where(project: project).where(args)

    query.order(order_by => direction)
  end

  def import(records)
    PlatformOrderItem.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:platform_order_id, :platform_container_type_id,
                                                                                                                  :related_container_guid, :platform_container_status_id] }, returning: :guid
  end
end
