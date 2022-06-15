# frozen_string_literal: true

class PlatformZoneAdapter < ApplicationAdapter
  def fetch
    import_zones
  end

  private

  def import_zones
    response = platform_client.query("integrator/erp/lists/zones")

    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |zone|
        records << { project_id: project.id,
                     guid: zone[:resource][:GUID],
                     description: zone[:resource][:Description] }
      end
      PlatformZoneRepository.new(nil, project).import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformZone", response.code)
  end
end
