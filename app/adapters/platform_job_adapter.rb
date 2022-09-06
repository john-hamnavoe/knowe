# frozen_string_literal: true

class PlatformJobAdapter < ApplicationAdapter
  def create(platform_job)
    return unless platform_job.guid.nil?

    response = post("integrator/erp/transport/jobs", platform_job.as_platform_json)
    if response.success?
      platform_job.update(guid: response.data[:resource], last_response_body: response.body, last_response_code: response.code)
    else
      platform_job.update(last_response_body: response.body, last_response_code: response.code)
    end
    response
  end

  def complete(platform_job)
    body = {
      "IsCompleted": true,
      "IsConfirmed": true,
      "IsFinanciallyConfirmed": true,
      "CompletedDate": Time.zone.today,
      "GUID": platform_job.guid
    }

    body = body.merge({ "PriceOverrides": [
      {
        "RelatedPriceGuid": platform_job.related_price_guid,
        "Guid": platform_job.price_override_guid,
        "OverrideRate": platform_job.override_rate.to_f,
        "IsSelected": true
      }
    ]}) if platform_job.price_override_guid.present? && platform_job.override_rate.present?
    
    response = put("integrator/erp/transport/jobs", platform_job.guid, body.to_json)
    if response.success?
      platform_job.update(is_completed: true, is_confirmed: true, is_financially_confirmed: true, last_response_body: response.body, last_response_code: response.code)
    else 
      platform_job.update(last_response_body: response.body, last_response_code: response.code)
    end      
    response
  end

  def fetch_price_override(platform_job)
    return unless platform_job.guid.present?

    response = query("integrator/erp/transport/jobs/#{platform_job.guid}")
    if response.success?
      platform_job.update(price_override_guid: response.data[:resource][:PriceOverrides][0][:Guid])
    end
    response
  end
end
