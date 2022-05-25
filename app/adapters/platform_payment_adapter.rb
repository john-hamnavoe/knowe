# frozen_string_literal: true

class PlatformPaymentAdapter < ApplicationAdapter
  def create(platform_payment)
    return unless platform_payment.guid.nil?

    response = post("integrator/erp/accounting/payments", platform_payment.as_platform_json)
    if response.success?
      platform_payment.update(guid: response.data[:resource], last_response_body: response.body, last_response_code: response.code)
    else
      platform_payment.update(last_response_body: response.body, last_response_code: response.code)
    end
    response
  end
end
