# frozen_string_literal: true

class PlatformAccountingPeriodAdapter < ApplicationAdapter
  def fetch
    import_accounting_periods
  end

  private

  def import_accounting_periods
    response = platform_client.query("integrator/erp/lists/accountingPeriods")

    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |accounting_period|
        records << { project_id: project.id,
                     guid: accounting_period[:resource][:GUID],
                     description: accounting_period[:resource][:Description],
                     start_date: accounting_period[:resource][:StartDate],
                     end_date: accounting_period[:resource][:EndDate],
                     is_closed: accounting_period[:resource][:IsClosed] }
      end
      PlatformAccountingPeriodRepository.new(nil, project).import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformAccountingPeriod", response.code)
  end
end
