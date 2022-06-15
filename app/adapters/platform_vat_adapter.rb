# frozen_string_literal: true

class PlatformVatAdapter < ApplicationAdapter
  def fetch
    import_vats
  end

  private

  def import_vats
    response = platform_client.query("integrator/erp/lists/vats")

    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |vat|
        records << { project_id: project.id,
                     guid: vat[:resource][:GUID],
                     description: vat[:resource][:Description],
                     rate: vat[:resource][:Rate],
                     is_deleted: vat[:resource][:IsDeleted] }
      end
      PlatformVatRepository.new(nil, project).import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformVat", response.code)
  end
end
