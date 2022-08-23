# frozen_string_literal: true

class PlatformLocationAdapter < ApplicationAdapter
  def create(platform_location)
    return unless platform_location.guid.nil?

    response = post("integrator/erp/directory/locations", platform_location.as_platform_json)
    if response.success?
      platform_location.update(guid: response.data[:resource], last_response_body: response.body, last_response_code: response.code)
    else
      platform_location.update(last_response_body: response.body, last_response_code: response.code)
    end
    response
  end

  def update(platform_location)
    return unless platform_location.guid.present?

    response = put("integrator/erp/directory/locations", platform_location.guid, platform_location.as_platform_json)
    platform_location.update(last_response_body: response.body, last_response_code: response.code)
    response    
  end
end
