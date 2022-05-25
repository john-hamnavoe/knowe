# frozen_string_literal: true

class PlatformWeighingTypeRepository < ApplicationRepository
  def all(args={}, order_by="description", direction="asc")
    query = PlatformWeighingType.where( project: project).where(args)
    

    query.order(order_by => direction)
  end

  def load_by_guid(guid)
    PlatformWeighingType.find_by(guid: guid,  project: project)
  end

  def gate_weighing_type
    PlatformWeighingType.find_by(description: "Gate",  project: project)
  end

  def import(records)
    PlatformWeighingType.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:description] }, returning: :guid
  end
end
