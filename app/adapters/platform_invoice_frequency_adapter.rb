# frozen_string_literal: true

class PlatformInvoiceFrequencyAdapter < ApplicationAdapter
  def fetch
    import_invoice_frequencys
  end

  private

  def import_invoice_frequencys
    response = platform_client.query("integrator/erp/lists/invoiceFrequencies")

    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |invoice_frequency|
        records << { project_id: project.id,
                     guid: invoice_frequency[:resource][:GUID],
                     description: invoice_frequency[:resource][:Description],
                     is_deleted: invoice_frequency[:resource][:IsDeleted] }
      end
      PlatformInvoiceFrequencyRepository.new(nil, project).import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformInvoiceFrequency", response.code)
  end
end
