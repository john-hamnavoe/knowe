# frozen_string_literal: true

class PlatformServiceAdapter < ApplicationAdapter
  def fetch
    import_services
  end

  private

  def import_services
    response = platform_client.query("integrator/erp/lists/services")

    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |service|
        records << { project_id: project.id,
                     guid: service[:resource][:GUID],
                     description: service[:resource][:Description],
                     short_name: service[:resource][:ShortName],
                     is_deleted: service[:resource][:IsDeleted],
                     analysis_code: service[:resource][:AnalysisCode],
                     external_description: service[:resource][:ExternalDescription] }
      end
      PlatformServiceRepository.new(nil, project).import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformService", response.code)
  end
end
