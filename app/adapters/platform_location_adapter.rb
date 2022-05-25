# frozen_string_literal: true

class PlatformLocationAdapter < ApplicationAdapter
  def create(platform_customer_site)
    return unless platform_customer_site.location_guid.nil?

    response = post("integrator/erp/directory/locations", platform_customer_site.as_platform_location_json)
    if response.success?
      platform_customer_site.update(location_guid: response.data[:resource], last_response_body: response.body, last_response_code: response.code)
    else
      platform_customer_site.update(last_response_body: response.body, last_response_code: response.code)
    end
    response
  end
end
