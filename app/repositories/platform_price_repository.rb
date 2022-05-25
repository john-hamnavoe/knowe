# frozen_string_literal: true

class PlatformPriceRepository < ApplicationRepository
  def all(args = {}, order_by = "description", direction = "asc")
    query = PlatformPrice.where( project: project).where(args)
    

    query.order(order_by => direction)
  end

  def load_by_guid(guid)
    PlatformPrice.find_by(guid: guid,  project: project)
  end

  def import(records)
    PlatformPrice.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:platform_service_agreement_id, :description, :platform_action_id, :platform_material_id, :platform_container_type_id, 
                                                                                                                                :platform_service_id, :amount, :effective_from, :effective_to] }, returning: :guid
  end
end
