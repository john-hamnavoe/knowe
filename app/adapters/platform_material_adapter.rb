# frozen_string_literal: true

class PlatformMaterialAdapter < ApplicationAdapter
  def fetch
    import_materials
  end

  private

  def import_materials
    page = 0

    loop do
      response = platform_client.query("integrator/erp/lists/materials?max=200&page=#{page}")

      if response.success?
        response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
        records = []
        response_data[:resource].each do |material|
          records << { project_id: project.id,
                       guid: material[:resource][:GUID],
                       description: material[:resource][:Description],
                       short_name: material[:resource][:ShortName],
                       is_deleted: material[:resource][:IsDeleted],
                       analysis_code: material[:resource][:AnalysisCode],
                       material_class_guid: material[:resource][:MaterialClassListItem][:Guid],
                       material_class_description: material[:resource][:MaterialClassListItem][:Description] }
        end
        platform_material_repository.import(records)
      end

      page += 1

      platform_setting_repository.update_last_response("PlatformMaterial", response.code)

      break if !response.success? || response_data[:resource].empty?
    end
  end

  def platform_material_repository
    @platform_material_repository ||= PlatformMaterialRepository.new(nil, project)
  end

  def platform_setting_repository
    @platform_setting_repository ||= PlatformSettingRepository.new(nil, project)
  end
end
