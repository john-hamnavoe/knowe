# frozen_string_literal: true

class PlatformZoneRepository < ApplicationRepository
  def all(args = {}, order_by = "description", direction = "asc")
    query = PlatformZone.where( project: project).where(args)
    
    query.order(order_by => direction)
  end

  def load_by_guid(guid)
    PlatformZone.find_by(guid: guid,  project: project)
  end

  def import(records)
    PlatformZone.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:description] }, returning: :guid
  end
end
