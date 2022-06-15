# frozen_string_literal: true

class PlatformDayOfWeekAdapter < ApplicationAdapter
  def fetch
    import_day_of_weeks
  end

  private

  def import_day_of_weeks
    response = platform_client.query("integrator/erp/lists/dayOfWeeks")

    if response.success?
      response_data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      records = []
      response_data[:resource].each do |day_of_week|
        records << { project_id: project.id,
                     guid: day_of_week[:resource][:GUID],
                     day_of_week: day_of_week[:resource][:DayOfWeek] }
      end
      PlatformDayOfWeekRepository.new(nil, project).import(records)
    end

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformDayOfWeek", response.code)
  end
end
