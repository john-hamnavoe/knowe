# frozen_string_literal: true

class PlatformExternalVehicleRepository < ApplicationRepository
  def all(args = {}, order_by = "registration", direction = "asc")
    query = PlatformExternalVehicle.where( project: project).where(args)

    query.order(order_by => direction)
  end

  def load_by_guid(guid)
    PlatformExternalVehicle.find_by(guid: guid,  project: project)
  end

  def import(records)
    PlatformExternalVehicle.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:registration, :description] }, returning: :guid
  end
end
