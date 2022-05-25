# frozen_string_literal: true

class PlatformCustomerTypeRepository < ApplicationRepository
  def all(args = {}, order_by = "description", direction = "asc")
    query = PlatformCustomerType.where( project: project).where(args)
    

    query.order(order_by => direction)
  end

  def load_by_guid(guid)
    PlatformCustomerType.find_by(guid: guid,  project: project)
  end

  def import(records)
    PlatformCustomerType.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:description, :is_deleted] }, returning: :guid
  end
end
