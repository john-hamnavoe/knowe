# frozen_string_literal: true

class PlatformCustomerStateAdapter < ApplicationAdapter
  def fetch
    import_customer_states
  end

  private

  def import_customer_states
    response = platform_client.query("integrator/erp/lists/customerStates")

    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |customer_state|
        records << { project_id: project.id,
                     guid: customer_state[:resource][:GUID],
                     description: customer_state[:resource][:Description],
                     is_deleted: customer_state[:resource][:IsDeleted] }
      end
      PlatformCustomerStateRepository.new(nil, project).import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformCustomerState", response.code)
  end
end
