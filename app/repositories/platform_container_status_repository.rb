# frozen_string_literal: true

class PlatformContainerStatusRepository < ApplicationRepository
  def all(args = {}, order_by = "description", direction = "asc")
    query = PlatformContainerStatus.where( project: project).where(args)
    

    query.order(order_by => direction)
  end

  def find_or_create(guid, description)
    container_status = PlatformContainerStatus.find_or_create_by(guid: guid,  project: project, description: description)
    container_status
  end

  def load_by_guid(guid)
    PlatformContainerStatus.find_by(guid: guid,  project: project)
  end

  def import(records)
    PlatformContainerStatus.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:description] }, returning: :guid
  end
end
