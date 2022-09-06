# frozen_string_literal: true

class PlatformCustomerSiteAdapter < ApplicationAdapter
  def create(platform_customer_site)
    if platform_customer_site.platform_location.guid.nil?
      response = post("integrator/erp/directory/locations", platform_customer_site.platform_location.as_platform_json)
      if response.success?
        platform_customer_site.update(location_guid: response.data[:resource], last_response_body: response.body, last_response_code: response.code)
        platform_customer_site.platform_location.update(guid: response.data[:resource], last_response_body: response.body, last_response_code: response.code)
      else
        platform_customer_site.update(last_response_body: response.body, last_response_code: response.code)
        platform_customer_site.platform_location.update(last_response_body: response.body, last_response_code: response.code)        
      end
      return response if platform_customer_site.location_guid.nil?
    end

    return unless platform_customer_site.guid.nil?

    response = post("integrator/erp/directory/sites", platform_customer_site.as_platform_json)
    if response.success?
      platform_customer_site.update(guid: response.data[:resource], last_response_body: response.body, last_response_code: response.code)
    else
      platform_customer_site.update(last_response_body: response.body, last_response_code: response.code)
    end
    response
  end

  def fetch(guid)
    load_standing_data
    import_customer_site(guid)
  end

  def fetch_by_account_number(account_numbers)
    load_standing_data
    import_customer_sites(account_numbers)
  end

  def fetch_by_customer_guid(customer_guid)
    load_standing_data
    import_customer_sites_by_customer_guid(customer_guid)
  end  

  def fetch_all(pages = nil)
    load_standing_data
    import_all_customer_sites(bookmark_repo.find(PlatformBookmark::CUSTOMER_SITE), pages)
    import_all_locations(bookmark_repo.find(PlatformBookmark::LOCATION), pages)
  end

  def fetch_all_customer_sites(pages = nil)
    load_standing_data
    import_all_customer_sites(bookmark_repo.find(PlatformBookmark::CUSTOMER_SITE), pages)
  end

  def fetch_all_locations(pages = nil)
    load_standing_data
    import_all_locations(bookmark_repo.find(PlatformBookmark::LOCATION), pages)
  end

  private

  def import_customer_site(guid)
    response = query("integrator/erp/directory/sites/#{guid}")
    return unless response.success?

    customer = customer_repo.load_by_guid(response.data[:resource][:RelatedCustomerGuid])
    customer_site_repo.import([customer_site_from_resource(response.data, customer.id)])
    import_location(response.data[:resource][:RelatedLocationGuid])
  end

  def import_location(guid)
    response = query("integrator/erp/directory/locations/#{guid}")
    return unless response.success?

    location_repo.import([location_from_resource(response.data)])
  end

  def import_customer_sites(ar_account_codes)
    records = []
    ar_account_codes.each do |ar_account_code|
      customer = acccount_customer_repo.load_by_account_code(ar_account_code.strip)
      next if customer.nil?

      response = query_with_filter("integrator/erp/directory/sites", "filter=RelatedCustomerGuid eq '#{customer.guid}'")
      records += customer_sites_from_response(response.data, customer.id) if response.success?
    end
    customer_site_repo.import(records)

    records.each do |record|
      import_location(record[:location_guid])
    end
  end

  def import_customer_sites_by_customer_guid(customer_guid)
    customer = customer_repo.load_by_guid(customer_guid)
    return if customer.nil?

    response = query_with_filter("integrator/erp/directory/sites", "filter=RelatedCustomerGuid eq '#{customer.guid}'")
    return unless response.success?

    records = customer_sites_from_response(response.data, customer.id)
    customer_site_repo.import(records)
    records.each do |record|
      import_location(record[:location_guid])
    end
  end  

  def import_all_customer_sites(bookmark, pages)
    @customers = customer_repo.all
    page = 1

    loop do
      response = query_changes("integrator/erp/directory/sites/changes", bookmark&.until_bookmark, bookmark&.cursor_bookmark)
      customer_site_repo.import(customer_sites_from_response(response.data)) if response.success?
      bookmark = bookmark_repo.create_or_update(PlatformBookmark::CUSTOMER_SITE, response.until, response.cursor)

      break if response.cursor.nil? || (pages.present? && page >= pages)
      
      page += 1
    end
  end

  def import_all_locations(bookmark, pages)
    page = 1

    loop do
      response = query_changes("integrator/erp/directory/locations/changes", bookmark&.until_bookmark, bookmark&.cursor_bookmark)
      location_repo.import(locations_from_response(response.data)) if response.success?
      bookmark = bookmark_repo.create_or_update(PlatformBookmark::LOCATION, response.until, response.cursor)
      
      break if response.cursor.nil? || (pages.present? && page >= pages)

      page += 1
    end
  end

  def customer_sites_from_response(response_data, customer_id = nil)
    records = []
    response_data[:resource].each do |customer_site|
      formated_customer_site = customer_site_from_resource(customer_site, customer_id)
      next if formated_customer_site.blank?

      records << formated_customer_site
    end
    records
  end

  def customer_site_from_resource(customer_site, customer_id = nil)
    company_outlet_id = @company_outlets.find { |co| co.guid == customer_site[:resource][:CompanyOutletListItem][:Guid] }&.id
    customer_site_state_id = customer_site[:resource][:CustomerSiteStateListItem].present? ? @customer_site_states.find { |c| c.guid == customer_site[:resource][:CustomerSiteStateListItem][:Guid] }&.id : nil
    zone_id = customer_site[:resource][:ZoneListItem].present? ? @zones.find { |c| c.guid ==  customer_site[:resource][:ZoneListItem][:Guid] }&.id : nil
    customer_id = customer_site[:resource][:RelatedCustomerGuid].present? ? @customers.find { |c| c.guid == customer_site[:resource][:RelatedCustomerGuid] }&.id : customer_id if customer_id.nil?
    # if nil customer id
    return {} if customer_id.nil?

    { project_id: project.id,
      guid: customer_site[:resource][:GUID],
      name: customer_site[:resource][:Name],
      reference: customer_site[:resource][:Reference],
      unqiue_customer_site_code: customer_site[:resource][:UniqueCustomerSiteCode],
      location_guid: customer_site[:resource][:RelatedLocationGuid],
      location_invoice_guid: customer_site[:resource][:RelatedLocationInvoiceGuid],
      platform_customer_id: customer_id,
      platform_company_outlet_id: company_outlet_id,
      platform_customer_site_state_id: customer_site_state_id,
      platform_zone_id: zone_id }
  end

  def locations_from_response(response_data)
    records = []
    response_data[:resource].each do |location|
      formated_location = location_from_resource(location)
      next if formated_location.blank?

      records << formated_location
    end
    records
  end

  def location_from_resource(location)
    zone_id = location[:resource][:Geo].present? && location[:resource][:Geo][:ZoneListItem].present? ? @zones.find { |c| c.guid == location[:resource][:Geo][:ZoneListItem][:Guid] }&.id : nil
    latitude = location[:resource][:Geo][:Latitude] if location[:resource][:Geo].present?
    longitude = location[:resource][:Geo][:Longitude] if location[:resource][:Geo].present?
    tel_no = location[:resource][:Address][:ContactMethods][:TelNo] if location[:resource][:Address][:ContactMethods].present?

    { project_id: project.id,
      guid: location[:resource][:GUID],
      description: location[:resource][:Description],
      legal_name: location[:resource][:LegalName],
      unique_reference: location[:resource][:UniqueReference],
      house_number: location[:resource][:Address][:HouseNumber],
      address_1: location[:resource][:Address][:Address1],
      address_2: location[:resource][:Address][:Address2],
      address_3: location[:resource][:Address][:Address3],
      address_4: location[:resource][:Address][:Address4],
      address_5: location[:resource][:Address][:Address5],
      address_6: location[:resource][:Address][:Address6],
      address_7: location[:resource][:Address][:Address7],
      address_8: location[:resource][:Address][:Address8],
      address_9: location[:resource][:Address][:Address9],            
      post_code: location[:resource][:Address][:Postcode],
      tel_no: tel_no,
      latitude: latitude,
      longitude: longitude,
      platform_zone_id: zone_id }
  end

  def load_standing_data
    @company_outlets = PlatformCompanyOutletRepository.new(user, project).all
    @customer_site_states = PlatformCustomerSiteStateRepository.new(user, project).all
    @zones = PlatformZoneRepository.new(user, project).all
  end

  def customer_repo
    @customer_repo ||= PlatformCustomerRepository.new(user, project)
  end

  def acccount_customer_repo
    @acccount_customer_repo ||= PlatformAccountCustomerRepository.new(user, project)
  end  

  def customer_site_repo
    @customer_site_repo ||= PlatformCustomerSiteRepository.new(user, project)
  end

  def location_repo
    @location_repo ||= PlatformLocationRepository.new(user, project)
  end

  def bookmark_repo
    @bookmark_repo ||= PlatformBookmarkRepository.new(user, project)
  end
end
