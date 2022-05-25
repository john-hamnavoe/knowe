# frozen_string_literal: true

class PlatformServiceRepository < ApplicationRepository
  def all(args = {}, order_by = "description", direction = "asc")
    query = PlatformService.where( project: project).where(args)

    query.order(order_by => direction)
  end

  def load_by_guid(guid)
    PlatformService.find_by(guid: guid,  project: project)
  end

  def import(records)
    PlatformService.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:description, :external_description, :short_name, :analysis_code, :is_deleted] }, returning: :guid
  end
end
