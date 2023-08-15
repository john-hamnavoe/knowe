# frozen_string_literal: true

class PlatformCustomerCategoryAdapter < ApplicationAdapter
  def fetch
    import_customer_categories
  end

  private

  def import_customer_categories
    return unless project.version_number >= Gem::Version.new("8.12")

    response = platform_client.query("integrator/erp/lists/customerCategories")

    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |customer_category|
        records << { project_id: project.id,
                     guid: customer_category[:resource][:GUID],
                     description: customer_category[:resource][:Description],
                     short_code: customer_category[:resource][:ShortCode],
                     is_deleted: customer_category[:resource][:IsDeleted] }
      end
      PlatformCustomerCategoryRepository.new(nil, project).import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformCustomerCategory", response.code)
  end
end
