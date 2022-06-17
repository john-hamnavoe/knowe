# frozen_string_literal: true

class PlatformContainerTypeAdapter < ApplicationAdapter
  def fetch
    import_container_types
  end

  private

  def import_container_types
    page = 0

    loop do
      response = platform_client.query("integrator/erp/lists/containerTypes?max=200&page=#{page}")

      if response.success?
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
        platform_container_type_repository.import(records)
      end

      page += 1

      platform_setting_repository.update_last_response("PlatformContainerType", response.code)

      break if !response.success? || response_data[:resource].empty?
    end
  end

  def platform_container_type_repository
    @platform_container_type_repository ||= PlatformContainerTypeRepository.new(nil, project)
  end

  def platform_setting_repository
    @platform_setting_repository ||= PlatformSettingRepository.new(nil, project)
  end  
end
