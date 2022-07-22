# frozen_string_literal: true

class PlatformCasualCustomerAdapter < ApplicationAdapter
  def create(platform_customer)
    return unless platform_customer.guid.nil?

    response = post("integrator/erp/directory/customers", platform_customer.as_platform_json)

    if response.success?
      platform_customer.update(guid: response.data[:resource], last_response_body: response.body, last_response_code: response.code)
    else
      platform_customer.update(last_response_body: response.body, last_response_code: response.code)
    end
    response
  end

  def update(platform_customer)
    return if platform_customer.guid.blank?

    response = put("integrator/erp/directory/customers", platform_customer.guid, platform_customer.as_platform_json)

    if response.success?
      platform_customer.update(guid: response.data[:resource], last_response_body: response.body, last_response_code: response.code)
    else
      platform_customer.update(last_response_body: response.body, last_response_code: response.code)
    end
    response
  end

  def fetch(guid)
    load_standing_data
    import_customer(guid)
    PlatformCustomerSiteAdapter.new(user, project).fetch_by_customer_guid(guid)
    PlatformOrderAdapter.new(user, project).fetch_by_customer_guid(guid)
    PlatformContactAdapter.new(user, project).fetch_by_customer_guid(guid)    
  end

  def fetch_all(pages = nil)
    load_standing_data
    import_all_customers(bookmark_repo.find(PlatformBookmark::CUSTOMER_CASUAL), pages)
  end

  private

  def import_customer(guid)
    response = query("integrator/erp/directory/customers/#{guid}")
    return unless response.success? && response.data[:resource][:ARAccountCode].nil?

    customer_repo.import([customer_from_resource(response.data)])
  end

  def import_all_customers(bookmark, pages)
    page = 1

    loop do 
      response = query_changes("integrator/erp/directory/customers/changes", bookmark&.until_bookmark, bookmark&.cursor_bookmark)
      customer_repo.import(customers_from_response(response.data)) if response.success?
      bookmark = bookmark_repo.create_or_update(PlatformBookmark::CUSTOMER_CASUAL, response.until, response.cursor)

      break if response.cursor.nil? || (pages.present? && page >= pages)

      page += 1
    end
  end

  def customers_from_response(response_data)
    records = []
    response_data[:resource].each do |customer|
      records << customer_from_resource(customer) if customer[:resource][:ARAccountCode].nil?
    end
    records
  end

  def customer_from_resource(customer)
    company_id = @companies.find { |c| c.guid == customer[:resource][:CompanyListItem][:Guid] }&.id
    currency_id = customer[:resource][:CurrencyListItem].present? ? @currencies.find { |c| c.guid == customer[:resource][:CurrencyListItem][:Guid] }&.id : nil
    customer_state_id = customer[:resource][:CustomerStateListItem].present? ? @customer_states.find { |c| c.guid == customer[:resource][:CustomerStateListItem][:Guid] }&.id : nil
    customer_type_id = customer[:resource][:CustomerTypeListItem].present? ? @customer_types.find { |c| c.guid == customer[:resource][:CustomerTypeListItem][:Guid] }&.id : nil
    platform_customer = PlatformCasualCustomer.new(project_id: project.id,
                                                    guid: customer[:resource][:GUID],
                                                    name: customer[:resource][:Name],
                                                    is_internal: customer[:resource][:IsInternal],
                                                    reference: customer[:resource][:Reference],
                                                    ar_account_code: customer[:resource][:ARAccountCode],
                                                    receive_service_updates_by_email: customer[:resource][:ReceiveServiceUpdatesByEmail],
                                                    receive_service_updates_by_text: customer[:resource][:ReceiveServiceUpdatesByText],
                                                    receive_marketing_updates_by_email: customer[:resource][:ReceiveMarketingUpdatesByEmail],
                                                    receive_marketing_updates_by_text: customer[:resource][:ReceiveMarketingUpdatesByText],
                                                    platform_company_id: company_id,
                                                    platform_currency_id: currency_id,
                                                    platform_customer_state_id: customer_state_id,
                                                    platform_customer_type_id: customer_type_id)

    platform_customer
  end

  def customer_repo
    @customer_repo ||= PlatformCasualCustomerRepository.new(user, project)
  end

  def bookmark_repo
    @bookmark_repo ||= PlatformBookmarkRepository.new(user, project)
  end

  def load_standing_data
    @companies = PlatformCompanyRepository.new(user,project).all
    @currencies = PlatformCurrencyRepository.new(user, project).all
    @customer_states = PlatformCustomerStateRepository.new(user, project).all
    @customer_types = PlatformCustomerTypeRepository.new(user, project).all
  end
end
