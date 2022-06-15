# frozen_string_literal: true

class PlatformPriorityAdapter < ApplicationAdapter
  def fetch
    import_priorities
  end

  private

  def import_priorities
    response = platform_client.query("integrator/erp/transport/orders?max=1&page=1")

    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |priority|
        records << { project_id: project.id,
                     guid: priority[:resource][:PriorityListItem][:Guid],
                     description: priority[:resource][:PriorityListItem][:Description] }
      end
      PlatformPriorityRepository.new(nil, project).import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformPriority", response.code)
  end
end
