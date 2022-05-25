# frozen_string_literal: true

class PlatformContactAdapter < ApplicationAdapter
  def create(platform_contact)
    return unless platform_contact.guid.nil?

    response = post("integrator/erp/directory/contacts", platform_contact.as_platform_json)
    if response.success?
      platform_contact.update(guid: response.data[:resource], last_response_body: response.body, last_response_code: response.code)
    else
      platform_contact.update(last_response_body: response.body, last_response_code: response.code)
    end
    response
  end
end
