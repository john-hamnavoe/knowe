# frozen_string_literal: true

class PlatformActionAdapter < ApplicationAdapter
  def fetch
    import_actions
  end

  private

  def import_actions
    response = platform_client.query("integrator/erp/lists/actions")
    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |action|
        records << { project_id: project.id,
                     guid: action[:resource][:GUID],
                     description: action[:resource][:Description],
                     short_action: action[:resource][:ShortAction],
                     is_deleted: action[:resource][:IsDeleted],
                     analysis_code: action[:resource][:AnalysisCode],
                     equivalent_haul: action[:resource][:EquivalentHaul] }
      end
      PlatformActionRepository.new(nil, project).import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformAction", response.code)
  end
end
