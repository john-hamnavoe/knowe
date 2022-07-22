# frozen_string_literal: true

class PlatformContactAdapter < ApplicationAdapter
  def create(platform_contact)
    # return unless platform_contact.guid.nil?

    response = post("integrator/erp/directory/contacts", platform_contact.as_platform_json)
    if response.success?
      platform_contact.update(guid: response.data[:resource], last_response_body: response.body, last_response_code: response.code)
    else
      platform_contact.update(last_response_body: response.body, last_response_code: response.code)
    end
    response
  end

  def fetch_all(pages = nil)
    load_standing_data
    import_all_contacts(bookmark_repo.find(PlatformBookmark::CONTACT), pages)
  end

  def fetch_by_account_number(account_numbers)
    load_standing_data
    import_contacts(account_numbers)
  end

  def fetch_by_customer_guid(customer_guid)
    load_standing_data
    import_contacts_by_customer_guid(customer_guid)
  end

  private

  def import_contacts(ar_account_codes)
    records = []
    ar_account_codes.each do |ar_account_code|
      customer = account_customer_repo.load_by_account_code(ar_account_code.strip)
      next if customer.nil?

      response = query_with_filter("integrator/erp/directory/contacts", "filter=RelatedCustomerGuid eq '#{customer.guid}'")
      records += contacts_from_response(response.data, customer.id) if response.success?
    end
    contact_repo.import(records) if records
  end

  def import_contacts_by_customer_guid(customer_guid)
    records = []
    customer = customer_repo.load_by_guid(customer_guid)
    return if customer.nil?

    response = query_with_filter("integrator/erp/directory/contacts", "filter=RelatedCustomerGuid eq '#{customer.guid}'")

    contact_repo.import(contacts_from_response(response.data, customer.id)) if response.success?
  end  

  def import_all_contacts(bookmark, pages)
    page = 1

    loop do 
      response = query_changes("integrator/erp/directory/contacts/changes", bookmark&.until_bookmark, bookmark&.cursor_bookmark)
      contact_repo.import(contacts_from_response(response.data)) if response.success?
      bookmark = bookmark_repo.create_or_update(PlatformBookmark::CONTACT, response.until, response.cursor)

      break if response.cursor.nil? || (pages.present? && page >= pages)

      page += 1
    end
  end

  def contacts_from_response(response_data, parent_customer_id = nil)
    customers = customer_repo.all({ guid: response_data[:resource].map { |r| r[:resource][:RelatedCustomerGuid] } }) if parent_customer_id.nil?
    records = []
    response_data[:resource].each do |contact|
      customer_id = parent_customer_id || customers.find { |c| c.guid == contact[:resource][:RelatedCustomerGuid] }&.id
      next if customer_id.nil?

      new_contact = contact_from_resource(contact, customer_id)
      records << new_contact
    end

    records
  end

  def contact_from_resource(contact, customer_id)
    contact_type_id = @contact_types.find { |ct| ct.guid == contact[:resource][:ContactTypeListItems][0][:ContactTypeListItem][:Guid] }&.id if contact[:resource][:ContactTypeListItems].length.positive?
    tel_no = contact[:resource][:ContactMethods][:TelNo] if contact[:resource][:ContactMethods].present?
    email = contact[:resource][:ContactMethods][:Email] if contact[:resource][:ContactMethods].present?

    {
      project_id: project.id,
      guid: contact[:resource][:GUID],
      forename: contact[:resource][:Forename],
      surname: contact[:resource][:Surname],
      tel_no: tel_no,
      email: email,
      platform_customer_id: customer_id,
      platform_contact_type_id: contact_type_id
    }
  end

  def load_standing_data
    @contact_types = PlatformContactTypeRepository.new(user, project).all
  end

  def contact_repo
    @contact_repo ||= PlatformContactRepository.new(user, project)
  end

  def customer_repo
    @customer_repo ||= PlatformCustomerRepository.new(user, project)
  end

  def account_customer_repo
    @account_customer_repo ||= PlatformAccountCustomerRepository.new(user, project)
  end

  def bookmark_repo
    @bookmark_repo ||= PlatformBookmarkRepository.new(user, project)
  end
end
