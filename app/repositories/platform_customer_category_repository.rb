# frozen_string_literal: true

class PlatformCustomerCategoryRepository < ApplicationRepository
  def all(args = {}, order_by = "description", direction = "asc")
    query = PlatformCustomerCategory.where( project: project).where(args)

    query.order(order_by => direction)
  end

  def load_by_guid(guid)
    PlatformCustomerCategory.find_by(guid: guid,  project: project)
  end

  def import(records)
    PlatformCustomerCategory.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:description, :short_code, :is_deleted] }, returning: :guid
  end
end
