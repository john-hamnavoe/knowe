# frozen_string_literal: true

class PlatformContainerTypeAdapter < ApplicationAdapter
  def fetch
    import_container_types
  end

  private

  def import_container_types
    response = platform_client.query("integrator/erp/lists/containerTypes")
    response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
    records = []
    response_data[:resource].each do |container_type|
      records << { project_id: project.id,
                   guid: container_type[:resource][:GUID],
                   description: container_type[:resource][:Description],
                   short_name: container_type[:resource][:ShortName],
                   is_deleted: container_type[:resource][:IsDeleted],
                   analysis_code: container_type[:resource][:AnalysisCode],
                   size: container_type[:resource][:Size],
                   tare_weight: container_type[:resource][:TareWeight],
                   external_description: container_type[:resource][:ExternalDescription] }
    end
    PlatformContainerTypeRepository.new(nil, project).import(records)

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformContainerType", response.code)
  end
end
