# frozen_string_literal: true

class PlatformWeighingTypeAdapter < ApplicationAdapter
  def fetch
    import_weighing_types
  end

  private

  def import_weighing_types
    response = platform_client.query("integrator/erp/lists/weighingTypes")

    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |weighing_type|
        records << { project_id: project.id,
                     guid: weighing_type[:resource][:GUID],
                     description: weighing_type[:resource][:Description] }
      end
      PlatformWeighingTypeRepository.new(nil, project).import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformWeighingType", response.code)
  end
end
