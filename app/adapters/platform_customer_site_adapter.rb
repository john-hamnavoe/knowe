# frozen_string_literal: true

class PlatformCustomerSiteAdapter < ApplicationAdapter
  def create(platform_customer_site)
    if platform_customer_site.location_guid.nil?
      response = post("integrator/erp/directory/locations", platform_customer_site.as_platform_location_json)
      if response.success?
        platform_customer_site.update(location_guid: response.data[:resource], last_response_body: response.body, last_response_code: response.code)
      else
        platform_customer_site.update(last_response_body: response.body, last_response_code: response.code)
      end
      return response if platform_customer_site.location_guid.nil?
    end

    return unless platform_customer_site.guid.nil?

    response = post("integrator/erp/directory/sites", platform_customer_site.as_platform_site_json)
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

  private

  def import_customer_site(guid)
    response = query("integrator/erp/directory/sites/#{guid}")
    return unless response.success?

    customer = customer_repo.load_by_guid(response.data[:resource][:RelatedCustomerGuid])
    customer_site_repo.import([customer_site_from_resource(response.data, customer.id)])
  end

  def import_customer_sites(ar_account_codes)
    records = []
    ar_account_codes.each do |ar_account_code|
      customer = customer_repo.load_by_account_code(ar_account_code.strip)
      next if customer.nil?

      response = query_with_filter("integrator/erp/directory/sites", "filter=RelatedCustomerGuid eq '#{customer.guid}'")
      records += customer_sites_from_response(response.data, customer.id) if response.success?
    end
    customer_site_repo.import(records)
  end

  def import_all_customer_sites(bookmark, pages)
    page = 1
    response = query_changes("integrator/erp/directory/sites/changes", bookmark&.until_bookmark, bookmark&.cursor_bookmark)
    customer_site_repo.import(customers_from_response(response.data)) if response.success?

    until response.cursor.nil? || (pages.present? && page >= pages)
      response = query_changes("integrator/erp/directory/sites/changes", nil, response.cursor)
      customer_site_repo.import(customers_from_response(response.data))
      page += 1
    end

    bookmark_repo.create_or_update(PlatformBookmark::CUSTOMER_SITE, response.until, response.cursor)
  end  

  def customer_sites_from_response(response_data, customer_id)
    records = []
    response_data[:resource].each do |customer_site|
      formated_customer_site = customer_site_from_resource(customer_site, customer_id)
      next if formated_customer_site.blank?

      records << formated_customer_site
    end
    records
  end

  def customer_site_from_resource(customer_site, customer_id)
    company_outlet_id = @company_outlets.find { |co| co.guid == customer_site[:resource][:CompanyOutletListItem][:Guid] }&.id
    customer_site_state_id = customer_site[:resource][:CustomerSiteStateListItem].present? ? @customer_site_states.find { |c| c.guid == customer_site[:resource][:CustomerSiteStateListItem][:Guid] }&.id : nil
    zone_id = customer_site[:resource][:ZoneListItem].present? ? @zones.find { |c| c.guid ==  customer_site[:resource][:ZoneListItem][:Guid] }&.id : nil
    # if nil customer id     
    return {} if customer_id.nil?

    location_response = query("integrator/erp/directory/locations/#{customer_site[:resource][:RelatedLocationGuid]}")
    location = location_response.data
    { project_id: project.id,
      
      guid: customer_site[:resource][:GUID],
      name: customer_site[:resource][:Name],
      reference: customer_site[:resource][:Reference],
      unqiue_customer_site_code: customer_site[:resource][:UniqueCustomerSiteCode],
      location_guid: customer_site[:resource][:RelatedLocationGuid],
      platform_customer_id: customer_id,
      platform_company_outlet_id: company_outlet_id,
      platform_customer_site_state_id: customer_site_state_id,
      platform_zone_id: zone_id,
      house_number: location[:resource][:Address][:HouseNumber],
      address_1: location[:resource][:Address][:Address1],
      address_2: location[:resource][:Address][:Address2],
      address_3: location[:resource][:Address][:Address3],
      address_4: location[:resource][:Address][:Address4],
      address_5: location[:resource][:Address][:Address5],
      post_code: location[:resource][:Address][:Postcode],
      tel_no: location[:resource][:Address][:ContactMethods][:TelNo],
      latitude: location[:resource][:Geo][:Latitude],
      longitude: location[:resource][:Geo][:Longitude] }
  end

  def load_standing_data
    @company_outlets = PlatformCompanyOutletRepository.new(user, project).all
    @customer_site_states = PlatformCustomerSiteStateRepository.new(user, project).all
    @zones = PlatformZoneRepository.new(user, project).all
  end

  def customer_repo
    @customer_repo ||= PlatformCustomerRepository.new(user, project)
  end

  def customer_site_repo
    @customer_site_repo ||= PlatformCustomerSiteRepository.new(user, project)
  end
end
