# frozen_string_literal: true

class PlatformVatRepository < ApplicationRepository
  def all(args = {}, order_by = "description", direction = "asc")
    query = PlatformVat.where( project: project).where(args)
    

    query.order(order_by => direction)
  end

  def load_by_guid(guid)
    PlatformVat.find_by(guid: guid,  project: project)
  end

  def import(records)
    PlatformVat.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:description, :rate, :is_deleted] }, returning: :guid
  end
end
