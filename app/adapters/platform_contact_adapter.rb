# frozen_string_literal: true

class PlatformContactAdapter < ApplicationAdapter
  def create(platform_contact)
    return unless platform_contact.guid.nil?

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

  private

  def import_all_contacts(bookmark, pages)
    page = 1
    response = query_changes("integrator/erp/directory/contacts/changes", bookmark&.until_bookmark, bookmark&.cursor_bookmark)
    contact_repo.import(contacts_from_response(response.data)) if response.success?

    until response.cursor.nil? || (pages.present? && page >= pages)
      response = query_changes("integrator/erp/directory/contacts/changes", nil, response.cursor)
      contact_repo.import(contacts_from_response(response.data))
      page += 1
    end

    bookmark_repo.create_or_update(PlatformBookmark::CONTACT, response.until, response.cursor)
  end

  def contacts_from_response(response_data, parent_customer_id = nil)
    customers = customer_repo.all({guid: response_data[:resource].map { |r| r[:resource][:RelatedCustomerGuid] }})
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
    contact_type_id = @contact_types.find { |ct| ct.guid == contact[:resource][:ContactTypeListItems][0][:ContactTypeListItem][:Guid] }&.id

    {
      project_id: project.id,
      guid: contact[:resource][:GUID],
      forename: contact[:resource][:Forename],
      surname: contact[:resource][:Surname],
      tel_no: contact[:resource][:ContactMethods][:TelNo],
      email: contact[:resource][:ContactMethods][:Email],
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

  def bookmark_repo 
    @bookmark_repo ||= PlatformBookmarkRepository.new(user, project)
  end
end
