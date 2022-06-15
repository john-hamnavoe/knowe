# frozen_string_literal: true

class PlatformInvoiceCycleAdapter < ApplicationAdapter
  def fetch
    import_invoice_cycles
  end

  private

  def import_invoice_cycles
    response = platform_client.query("integrator/erp/lists/invoiceCycles")

    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |invoice_cycle|
        records << { project_id: project.id,
                     guid: invoice_cycle[:resource][:GUID],
                     description: invoice_cycle[:resource][:Description],
                     is_deleted: invoice_cycle[:resource][:IsDeleted] }
      end
      PlatformInvoiceCycleRepository.new(nil, project).import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformInvoiceCycle", response.code)
  end
end
