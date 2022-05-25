# frozen_string_literal: true

class PlatformCustomerSiteStateRepository < ApplicationRepository
  def all(args = {}, order_by = "description", direction = "asc")
    query = PlatformCustomerSiteState.where( project: project).where(args)
    

    query.order(order_by => direction)
  end

  def load_by_guid(guid)
    PlatformCustomerSiteState.find_by(guid: guid,  project: project)
  end

  def active_customer_site_state
    PlatformCustomerSiteState.find_by(description: "Active",  project: project)
  end

  def import(records)
    PlatformCustomerSiteState.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:description, :is_deleted] }, returning: :guid
  end
end
