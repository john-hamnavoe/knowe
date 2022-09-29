# frozen_string_literal: true

class PlatformContainerAdapter < ApplicationAdapter
  def create(platform_container)
    return unless platform_container.guid.nil?

    response = post("integrator/erp/directory/containers", platform_container.as_platform_json)
    if response.success?
      platform_container.update(guid: response.data[:resource], last_response_body: response.body, last_response_code: response.code)
    else
      platform_container.update(last_response_body: response.body, last_response_code: response.code)
    end
    response
  end

  def update(platform_container, *attributes)
    return if platform_container.guid.blank?

    response = put("integrator/erp/directory/containers", platform_container.guid, platform_container.as_platform_json(*attributes))

    response
  end  

  def fetch_all(pages = nil)
    load_standing_data
    import_all_containers(bookmark_repo.find(PlatformBookmark::CONTAINER), pages)
  end

  def fetch_by_guid(guid)
    load_standing_data
    import_container(guid)
  end

  private

  def import_container(guid)
    response = query("/integrator/erp/directory/containers/#{guid}")
    container_repo.import([container_from_resource(response.data)]) if response.success?
  end

  def import_all_containers(bookmark, pages)
    page = 1
    loop do 
      response = query_changes("/integrator/erp/directory/containers/changes", bookmark&.until_bookmark, bookmark&.cursor_bookmark)
      container_repo.import(containers_from_response(response.data)) if response.success?
      bookmark = bookmark_repo.create_or_update(PlatformBookmark::CONTAINER, response.until, response.cursor) if response.success?

      break if response.cursor.nil? || (pages.present? && page >= pages)

      page += 1
    end    
  end

  def containers_from_response(response_data)
    records = []
    response_data[:resource].each do |container|
      new_container = container_from_resource(container)
      records << new_container
    end

    records
  end

  def container_from_resource(container)
    latitude = container[:resource][:Geo][:Lat] if container[:resource][:Geo].present?
    longitude = container[:resource][:Geo][:Long] if container[:resource][:Geo].present?
    company_outlet_id = container[:resource][:CompanyOutletListItem].present? ? @company_outlets.find { |co| co.guid == container[:resource][:CompanyOutletListItem][:Guid] }&.id : nil
    container_status_id = container[:resource][:ContainerStatusListItem].present? ? @container_status.find { |co| co.guid == container[:resource][:ContainerStatusListItem][:Guid] }&.id : nil
    container_type_id = @container_types.find { |c| c.guid == container[:resource][:ContainerTypeListItem][:Guid] }&.id

    {
      project_id: project.id,
      guid: container[:resource][:GUID],
      tag: container[:resource][:Tag],
      serial_no: container[:resource][:SerialNo],
      note: container[:resource][:Note],
      is_commercial: container[:resource][:IsCommercial],
      is_stoplisted: container[:resource][:IsStoplisted],
      latitude: latitude,
      longitude: longitude,
      platform_container_type_id: container_type_id,
      platform_company_outlet_id: company_outlet_id,
      platform_container_status_id: container_status_id
    }
  end

  def load_standing_data
    @company_outlets = PlatformCompanyOutletRepository.new(user, project).all
    @container_types = PlatformContainerTypeRepository.new(user, project).all
    @container_status = PlatformContainerStatusRepository.new(user, project).all
  end

  def container_repo
    @container_repo ||= PlatformContainerRepository.new(user, project)
  end

  def order_item_repo
    @order_item_repo ||= PlatformOrderItemRepository.new(user, project)
  end

  def bookmark_repo
    @bookmark_repo ||= PlatformBookmarkRepository.new(user, project)
  end
end
