# frozen_string_literal: true

class PlatformPaymentPointAdapter < ApplicationAdapter
  def fetch
    import_payment_points
  end

  private

  def import_payment_points
    response = platform_client.query("integrator/erp/lists/paymentPoints")

    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |payment_point|
        records << { project_id: project.id,

                     guid: payment_point[:resource][:GUID],
                     description: payment_point[:resource][:Description] }
      end
      PlatformPaymentPointRepository.new(nil, project).import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformPaymentPoint", response.code)
  end
end
