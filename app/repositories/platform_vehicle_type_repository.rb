# frozen_string_literal: true

class PlatformVehicleTypeRepository < ApplicationRepository
  def all(args={}, order_by="description", direction="asc")
    query = PlatformVehicleType.where( project: project).where(args)

    query.order(order_by => direction)
  end

  def load_by_guid(guid)
    PlatformVehicleType.find_by(guid: guid,  project: project)
  end

  def import(records)
    PlatformVehicleType.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:description, :code, :collection_type, :is_deleted] }, returning: :guid
  end
end
