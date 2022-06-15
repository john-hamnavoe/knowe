# frozen_string_literal: true

class PlatformPickupIntervalAdapter < ApplicationAdapter
  def fetch
    import_pickup_intervals
  end

  private

  def import_pickup_intervals
    response = platform_client.query("integrator/erp/lists/pickupIntervals")

    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |pickup_interval|
        records << { project_id: project.id,
                     guid: pickup_interval[:resource][:GUID],
                     description: pickup_interval[:resource][:Description] }
      end
      PlatformPickupIntervalRepository.new(nil, project).import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformPickupInterval", response.code)
  end
end
