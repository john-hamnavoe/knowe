# frozen_string_literal: true

class PlatformDocumentDeliveryTypeRepository < ApplicationRepository
  def all(args = {}, order_by = "description", direction = "asc")
    query = PlatformDocumentDeliveryType.where( project: project).where(args)
    

    query.order(order_by => direction)
  end

  def load_by_guid(guid)
    PlatformDocumentDeliveryType.find_by(guid: guid,  project: project)
  end

  def import(records)
    PlatformDocumentDeliveryType.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:description, :is_active] }, returning: :guid
  end
end
