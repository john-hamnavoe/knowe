# frozen_string_literal: true

class PlatformSicCodeRepository < ApplicationRepository
  def all(args = {}, order_by = "code_2007", direction = "asc")
    query = PlatformSicCode.where(project: project).where(args)

    query.order(order_by => direction)
  end

  def load(id)
    PlatformSicCode.find_by(id: id, project: project)
  end

  def load_by_guid(guid)
    PlatformSicCode.find_by(guid: guid, project: project)
  end

  def import(records)
    PlatformSicCode.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:description_2007, :code_2007, :description_2003, :code_2003, :is_deleted] }, returning: :guid
  end
end
