# frozen_string_literal: true

class PlatformCompanyOutletRepository < ApplicationRepository
  def all(args = {}, order_by = "description", direction = "asc")
    query = PlatformCompanyOutlet.where( project: project).where(args)

    query.order(order_by => direction)
  end

  def load_by_guid(guid)
    PlatformCompanyOutlet.find_by(guid: guid,  project: project)
  end

  def import(records)
    PlatformCompanyOutlet.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:description, :location_guid, :abbreviated_description, :vat_registration_number, :platform_company_id, :analysis_code, :is_deleted] }, returning: :guid
  end
end
