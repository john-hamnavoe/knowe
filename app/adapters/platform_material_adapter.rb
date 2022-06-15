# frozen_string_literal: true

class PlatformMaterialAdapter < ApplicationAdapter
  def fetch
    import_materials
  end

  private

  def import_materials
    response = platform_client.query("integrator/erp/lists/materials")

    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |material|
        records << { project_id: project.id,
                     guid: material[:resource][:GUID],
                     description: material[:resource][:Description],
                     short_name: material[:resource][:ShortName],
                     is_deleted: material[:resource][:IsDeleted],
                     analysis_code: material[:resource][:AnalysisCode] }
      end
      PlatformMaterialRepository.new(nil, project).import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformMaterial", response.code)
  end
end
