# frozen_string_literal: true

class PlatformAccountingPeriodRepository < ApplicationRepository
  def all(args = {}, order_by = "description", direction = "asc")
    query = PlatformAccountingPeriod.where( project: project).where(args)

    query.order(order_by => direction)
  end

  def load_by_guid(guid)
    PlatformAccountingPeriod.find_by(guid: guid,  project: project)
  end

  def import(records)
    PlatformAccountingPeriod.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:description, :start_date, :end_date, :is_closed] }, returning: :guid
  end
end
