# frozen_string_literal: true

class PlatformCustomerSiteStateAdapter < ApplicationAdapter
  def fetch
    import_customer_site_states
  end

  private

  def import_customer_site_states
    response = platform_client.query("integrator/erp/lists/customerSiteStates")

    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |customer_site_state|
        records << { project_id: project.id,
                     guid: customer_site_state[:resource][:GUID],
                     description: customer_site_state[:resource][:Description],
                     is_deleted: customer_site_state[:resource][:IsDeleted] }
      end
      PlatformCustomerSiteStateRepository.new(nil, project).import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformCustomerSiteState", response.code)
  end
end
