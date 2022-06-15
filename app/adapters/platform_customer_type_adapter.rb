# frozen_string_literal: true

class PlatformCustomerTypeAdapter < ApplicationAdapter
  def fetch
    import_customer_types
  end

  private

  def import_customer_types
    response = platform_client.query("integrator/erp/lists/customerTypes")

    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |customer_type|
        records << { project_id: project.id,
                     guid: customer_type[:resource][:GUID],
                     description: customer_type[:resource][:Description],
                     is_deleted: customer_type[:resource][:IsDeleted] }
      end
      PlatformCustomerTypeRepository.new(nil, project).import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformCustomerType", response.code)
  end
end
