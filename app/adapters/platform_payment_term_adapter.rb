# frozen_string_literal: true

class PlatformPaymentTermAdapter < ApplicationAdapter
  def fetch
    import_payment_terms
  end

  private

  def import_payment_terms
    response = platform_client.query("integrator/erp/lists/paymentTerms")

    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |payment_term|
        records << { project_id: project.id,
                     guid: payment_term[:resource][:GUID],
                     description: payment_term[:resource][:Description],
                     is_deleted: payment_term[:resource][:IsDeleted] }
      end
      PlatformPaymentTermRepository.new(nil, project).import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformPaymentTerm", response.code)
  end
end
