# frozen_string_literal: true

class PlatformLocationRepository < ApplicationRepository
  def all(args={}, order_by="description", direction="asc")
    query = PlatformLocation.where( project: project).where(args)
    query.order(order_by => direction)
  end

  def load(id)
    PlatformLocation.find_by(id: id,  project: project)
  end

  def load_by_guid(guid)
    PlatformLocation.find_by(guid: guid,  project: project)
  end

  def import(records)
    PlatformLocation.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:description, :legal_name, :unique_reference, :house_number, :address_1,
                                                                                                                 :address_2, :address_3, :address_4, :address_5, :post_code, :tel_no,
                                                                                                                 :platform_zone_id, :latitude, :longitude] }, returning: :guid

    build_customer_site_links
  end

  private 

  def build_customer_site_links
    ActiveRecord::Base.connection.exec_update(<<-EOQ)
    UPDATE platform_customer_sites
       SET platform_location_id = platform_locations.id
      FROM platform_locations
     WHERE platform_customer_sites.location_guid = platform_locations.guid AND
           platform_customer_sites.project_id = platform_locations.project_id AND
           (platform_customer_sites.platform_location_id IS NULL OR
           (platform_customer_sites.platform_location_id != platform_locations.id))
    EOQ

    ActiveRecord::Base.connection.exec_update(<<-EOQ)
    UPDATE platform_customer_sites
       SET platform_invoice_location_id = platform_locations.id
      FROM platform_locations
     WHERE platform_customer_sites.location_invoice_guid = platform_locations.guid AND
           platform_customer_sites.project_id = platform_locations.project_id AND
           (platform_customer_sites.platform_invoice_location_id IS NULL OR
           (platform_customer_sites.platform_invoice_location_id != platform_locations.id))
    EOQ
  end
end
