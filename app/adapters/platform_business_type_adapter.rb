# frozen_string_literal: true

class PlatformBusinessTypeAdapter < ApplicationAdapter
  def fetch
    import_business_types
  end

  private

  def import_business_types
    response = platform_client.query("integrator/erp/lists/businessTypes")
    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |business_type|
        records << { project_id: project.id,
                     guid: business_type[:resource][:GUID],
                     description: business_type[:resource][:Description],
                     is_deleted: business_type[:resource][:IsDeleted] }
      end
      PlatformBusinessTypeRepository.new(nil, project).import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformBusinessType", response.code)
  end
end
