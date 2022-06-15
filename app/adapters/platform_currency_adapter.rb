# frozen_string_literal: true

class PlatformCurrencyAdapter < ApplicationAdapter
  def fetch
    import_currencies
  end

  private

  def import_currencies
    response = platform_client.query("integrator/erp/lists/currencies")

    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |currency|
        records << { project_id: project.id,
                     guid: currency[:resource][:GUID],
                     description: currency[:resource][:Description],
                     symbol: currency[:resource][:Symbol],
                     integration_code: currency[:resource][:IntegrationCode],
                     is_deleted: currency[:resource][:IsDeleted] }
      end
      PlatformCurrencyRepository.new(nil, project).import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformCurrency", response.code)
  end
end
