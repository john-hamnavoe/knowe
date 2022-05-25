# frozen_string_literal: true

class PlatformItemRentalRepository < ApplicationRepository
  def import(records)
    PlatformItemRental.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:platform_order_id, :quantity, :platform_action_id, :platform_container_type_id,
                                                                                                                                     :platform_price_id, :is_arrears, :start_date] }, returning: :guid
  end
end
