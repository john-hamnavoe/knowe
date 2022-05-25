# frozen_string_literal: true

class PlatformDayOfWeekRepository < ApplicationRepository
  def all(args = {}, order_by = "day_of_week", direction = "asc")
    query = PlatformDayOfWeek.where( project: project).where(args)

    query.order(order_by => direction)
  end

  def load_by_guid(guid)
    PlatformDayOfWeek.find_by(guid: guid,  project: project)
  end

  def import(records)
    PlatformDayOfWeek.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:day_of_week] }, returning: :guid
  end
end
