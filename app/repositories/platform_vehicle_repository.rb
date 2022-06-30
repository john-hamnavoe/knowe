# frozen_string_literal: true

class PlatformVehicleRepository < ApplicationRepository
  def all(args = {}, order_by = "registration_no", direction = "asc")
    query = PlatformVehicle.where( project: project).where(args)

    query.order(order_by => direction)
  end

  def load_by_guid(guid)
    PlatformVehicle.find_by(guid: guid,  project: project)
  end

  def import(records)
    PlatformVehicle.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:registration_no, :vehicle_code, :platform_company_outlet_id, :platform_vehicle_type_id] }, returning: :guid
  end
end
