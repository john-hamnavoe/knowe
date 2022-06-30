# frozen_string_literal: true

class PlatformVehicleTypeAdapter < ApplicationAdapter
  def fetch
    import_vehicle_types
  end

  private

  def import_vehicle_types
    response = platform_client.query("integrator/erp/lists/vehicleTypes")

    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |vehicle_type|
        records << { project_id: project.id,
                     guid: vehicle_type[:resource][:GUID],
                     description: vehicle_type[:resource][:Description],
                     code: vehicle_type[:resource][:Code],
                     collection_type: vehicle_type[:resource][:CollectionType],
                     is_deleted: vehicle_type[:resource][:IsDeleted] }
      end
      PlatformVehicleTypeRepository.new(nil, project).import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformVehicleType", response.code)
  end
end
