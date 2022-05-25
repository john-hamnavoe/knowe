# frozen_string_literal: true

class PlatformCompanyRepository < ApplicationRepository
  def all(args = {}, order_by = "description", direction = "asc")
    query = PlatformCompany.where( project: project).where(args)
    

    query.order(order_by => direction)
  end

  def load_by_guid(guid)
    PlatformCompany.find_by(guid: guid,  project: project)
  end

  def import(records)
    PlatformCompany.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:description, :analysis_code, :is_deleted] }, returning: :guid
  end
end
