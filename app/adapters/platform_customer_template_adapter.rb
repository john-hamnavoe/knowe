# frozen_string_literal: true

class PlatformCustomerTemplateAdapter < ApplicationAdapter
  def fetch
    import_customer_templates
  end

  private

  def import_customer_templates
    response = platform_client.query("integrator/erp/lists/customerTemplates")

    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |customer_template|
        records << { project_id: project.id,
                     guid: customer_template[:resource][:GUID],
                     description: customer_template[:resource][:Description],
                     is_deleted: customer_template[:resource][:IsDeleted] }
      end
      PlatformCustomerTemplateRepository.new(nil, project).import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformCustomerTemplate", response.code)
  end
end
