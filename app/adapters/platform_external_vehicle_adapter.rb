# frozen_string_literal: true

class PlatformExternalVehicleAdapter < ApplicationAdapter
  def fetch
    import_external_vehicles
  end

  private

  def import_external_vehicles
    response = platform_client.query("integrator/erp/fleet/externalVehicles")

    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |external_vehicle|
        records << { project_id: project.id,
                     guid: external_vehicle[:resource][:GUID],
                     registration: external_vehicle[:resource][:Registration],
                     description: external_vehicle[:resource][:Description] }
      end
      PlatformExternalVehicleRepository.new(nil, project).import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformExternalVehicle", response.code)
  end
end
