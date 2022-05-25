# frozen_string_literal: true

class PlatformWeighingAdapter < ApplicationAdapter
  def create(platform_weighing)
    response = post("integrator/erp/scale/weighings", platform_weighing.as_platform_json)
    if response.success?
      platform_weighing.update(guid: response.data[:resource], last_response_body: response.body, last_response_code: response.code)
    else
      platform_weighing.update(last_response_body: response.body, last_response_code: response.code)
    end
    response
  end

  def update(platform_weighing)
    response = put("integrator/erp/scale/weighings", platform_weighing.guid, platform_weighing.as_platform_complete_json)
    if response.success?
      platform_weighing.update(guid: response.data[:resource], last_response_body: response.body, last_response_code: response.code)
    else
      platform_weighing.update(last_response_body: response.body, last_response_code: response.code)
    end
    response
  end
end
