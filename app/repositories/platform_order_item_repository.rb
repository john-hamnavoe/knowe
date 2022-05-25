# frozen_string_literal: true

class PlatformOrderItemRepository < ApplicationRepository
  def import(records)
    PlatformOrderItem.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:platform_order_id, :platform_container_type_id,
                                                                                                                                    :platform_container_status_id] }, returning: :guid
  end
end
