# frozen_string_literal: true

class PlatformCustomerSiteRepository < ApplicationRepository
  def all(args={}, params=nil, order_by="name", direction="asc")
    query = PlatformCustomerSite.where( project: project).where(args)
    query = query.where("lower(name) LIKE :keyword OR lower(reference) LIKE :keyword", keyword: "%#{params[:keywords].downcase}%") if params && params[:keywords].present?

    query.order(order_by => direction)
  end

  def load(id)
    PlatformCustomerSite.find_by(id: id,  project: project)
  end

  def load_by_guid(guid)
    PlatformCustomerSite.find_by(guid: guid,  project: project)
  end

  def import(records)
    PlatformCustomerSite.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:name, :reference, :unqiue_customer_site_code, :platform_customer_id, :platform_company_outlet_id,
                                                                                                                                       :platform_customer_site_state_id, :platform_zone_id, :location_guid] }, returning: :guid
  end
end
