# frozen_string_literal: true

class PlatformActionRepository < ApplicationRepository
  def all(args = {}, order_by = "description", direction = "asc")
    query = PlatformAction.where(project: project).where(args)

    query.order(order_by => direction)
  end

  def import(records)
    PlatformAction.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:description, :analysis_code, :is_deleted, :short_action, :equivalent_haul] }, returning: :guid
  end
end
